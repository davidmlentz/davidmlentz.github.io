# How To Set Up the Latest MediaWiki with Lighttpd on Ubuntu 14.04

### Introduction

MediaWiki is a popular open source wiki platform that can be used for public or internal collaborative content publishing.  MediaWiki is used for many of the most popular wikis on the internet including Wikipedia, the site that the project was originally designed to serve.

In this guide, we will be setting up the latest version of MediaWiki on an Ubuntu 14.04 server.  We will use the `lighttpd` web server to make the actual content available, `php-fpm` to handle dynamic processing, and `mysql` to store our wiki's data.

## Prerequisites

To complete this guide, you should have access to a clean Ubuntu 14.04 server instance.  On this system, you should have a non-root user configured with `sudo` privileges for administrative tasks.  You can learn how to set this up by following our [Ubuntu 14.04 initial server setup guide](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04).

When you are ready to continue, log into your server with your `sudo` user and get started below.

## Step 1 — Install the server components

In this section, we'll install the programs that support MediaWiki (which we'll install a little later). First, let's make sure your server is up to date. (You may be prompted for your `sudo` password at this point, but you should only have to enter it once.)

	sudo apt-get -y update

Next, install the `lighttpd` web server:

	sudo apt-get -y install lighttpd

Then install PHP (including `php-fpm`):

	sudo apt-get -y install php5-cgi php5-fpm php5-cli

Now install MySQL. You'll be asked to create a MySQL root password. **Remember your password.**
 
	sudo apt-get -y install mysql-server

The next command will make your database more secure:

	sudo mysql_secure_installation

You'll have to enter the password you just created, and it'll ask if you want to change it (but don't).

![Enter current password prompt](http://i.imgur.com/Iiegcek.png "Enter current password prompt")

![Change password prompt](http://i.imgur.com/wcD4tIb.png "Change password prompt")

After that, you can accept the default answers on the remaining questions by just hitting "ENTER":

![Remove anonymous users prompt](http://i.imgur.com/vityhuJ.png "Remove anonymous users prompt")

![Disallow root login prompt](http://i.imgur.com/xKkm4Za.png "Disallow root login prompt")

![Remove test database prompt](http://i.imgur.com/EXtahJC.png "Remove test database prompt")

![Reload privileges tables prompt](http://i.imgur.com/fcTWtw4.png "Reload privileges tables prompt")

## Step 2 — Configure MySQL and Create Credentials for MediaWiki

We've installed MySQL, which is the database MediaWiki uses to store content. Now let's configure it so it's ready to use. First, set up some initial tables:

	sudo mysql_install_db

Next, log in to MySQL. You'll need to provide the password you created earlier:

	/usr/bin/mysql -u root -p

You'll see a different command prompt, confirming that you're about to issue commands to the database program. 

![MySQL command prompt](http://i.imgur.com/u6tqi18.png "MySQL command prompt")

Now that you're talking to the MySQL server, create a user and database specifically for MediaWiki to use. (Change the password in this command to a strong password you'll remember.)

	CREATE DATABASE wikidb; GRANT ALL PRIVILEGES ON wikidb.* TO 'wikiuser'@'localhost' IDENTIFIED BY 'password';

Now you can exit MySQL:

	exit

Next let's install phpMyAdmin:

	sudo apt-get -y install phpmyadmin

You'll see this prompt asking which web server you want phpMyAdmin to use:

![phpMyAdmin installation prompt](http://i.imgur.com/eRMRBkY.png "phpMyAdmin installation prompt")

Choose `lighttpd`: use the arrow key to move your cursor, then hit the spacebar to select the `lighttpd` option, then tab to "Ok" and hit "ENTER" to proceed. 

Next you'll be asked to configure the database. We've already done that, so choose "No", and "ENTER" to proceed. 

![phpMyAdmin database configuration](http://i.imgur.com/dwkjrZH.png "phpMyAdmin database configuration")

## Step 3 — Configure PHP-FPM and Lighttpd

`PHP-FPM` and `lighttpd` (which, by the way, is pronounced "lighty") will give MediaWiki the web server and server-side processing it requires. In this section, we'll 
get those pieces configured properly.

First we need to modify the `php.ini` file, which defines how PHP works. We just need to uncomment one line to enable `lighttpd` to use PHP. First, open the file:

	sudo nano /etc/php5/fpm/php.ini

Now find the line that reads `;cgi.fix_pathinfo=1` (Right: it starts with a semicolon. That's the problem.) Uncomment the line by deleting just the semicolon, then save and exit.

Next, change directory so we can edit a `lighttpd` configuration file:

	cd /etc/lighttpd/conf-available/

Truncate (or empty) the file `15-fastcgi-php.conf` and open it for editing:

	sudo truncate -s 0 15-fastcgi-php.conf
	sudo nano 15-fastcgi-php.conf

Paste this content into the file, then save and exit.

	# /usr/share/doc/lighttpd-doc/fastcgi.txt.gz
	# http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:ConfigurationOptions#mod_fastcgi-fastcgi
	
	## Start an FastCGI server for php (needs the php5-cgi package)
	fastcgi.server += ( ".php" =>
	        ((
	                "socket" => "/var/run/php5-fpm.sock",
	                "broken-scriptfilename" => "enable"
	        ))
	)

Now that we've modified these files, we need to tell `lighttpd` to reload its configuration so the changes take effect:

	sudo /etc/init.d/lighttpd force-reload

## Step 4 — Install MediaWiki

Now we're ready to install MediaWiki. First, move into the right directory:

	cd /var/www

Next, use `wget` to download a compressed archive file containing the latest version of MediaWiki:

	sudo wget https://releases.wikimedia.org/mediawiki/1.26/mediawiki-1.26.2.tar.gz

Uncompress the file:

	sudo gunzip mediawiki-1.26.2.tar.gz

Then extract the files from the archive, placing all the MediaWiki files onto your server:

	sudo tar -xvf mediawiki-1.26.2.tar

Now create a symbolic link so your MediaWiki URL will reference "mediawiki" instead of "mediawiki-1.26.2":

	sudo ln -s mediawiki-1.26.2 mediawiki

Now you can browse to your MediaWiki installation at `http://[your server ip]/mediawiki` and complete your setup in the browser.

![Your MediaWiki installation page](http://i.imgur.com/XspfMMo.png "Your MediaWiki installation page")

Click "set up the wiki" to proceed. Select the language you want MediaWiki to use, and continue.

On the next screen, look for text that reads "The environment has been checked. You can install MediaWiki." Click "Continue".
 
![The environment has been checked](http://i.imgur.com/ZD55bi0.png "The environment has been checked")
 
Next, tell MediaWiki how to access your database. Use the **Database host** and **Database name** default values provided. For your **Database table prefix**, type "my\_wiki\_tables". Enter the MySQL root account information in the **Database username** and **Database password** fields. Click "Continue".

![MediaWiki installation](http://i.imgur.com/eCLz7BP.png "MediaWiki installation") 
	
On the next screen, uncheck the box labeled "Use the same account as for installation" and enter the username "wikiuser" and the corresponding password you created above. Leave the **Storage engine** and **Database character set** values at their defaults.
	
![MediaWiki installation](http://i.imgur.com/XeqZXcC.png "MediaWiki installation") 
 
Next, give your wiki a name and create an administrator account for yourself. At the bottom of this form, select "I'm bored already, just install the wiki."
 
When the final installation page loads, your browser should automatically download a file named LocalSettings.php. Open that in a text editor and copy the entire contents to your clipboard.
 
![MediaWiki installation](http://i.imgur.com/5EbFbrs.png "MediaWiki installation") 
	
Back at the command line, open LocalSettings.php on the server:

	sudo nano /var/www/mediawiki/LocalSettings.php
	
Paste the contents of your clipboard and save the file.
	
Finally, go back to your browser and click the `enter your wiki` link.
 

	


## Conclusion

Congratulations! You now have a functioning MediaWiki site. There's no content, but it's ready for you and for your collaborators to begin 
building out your site. 

See the MediaWiki documentation at [mediawiki.org](https://www.mediawiki.org) for information on how to add users and content.
