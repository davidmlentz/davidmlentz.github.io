#! /bin/sh
# apc_create.sh
# last update: 20070228

# Edit /etc/apt/sources.list  This will allow us use apt-get to grab some old pacakges (python2.1, below)
echo "" >> /etc/apt/sources.list
echo "deb http://archive.debian.org/debian-archive/ woody contrib main non-free" >> /etc/apt/sources.list

# It's a new installation -- grab the latest Debian changes:
apt-get update

# Get the Debian packages necessary to function as a Digibuddy:
apt-get -y install libconfig-inifiles-perl tftp libsoap-lite-perl libtimedate-perl libwww-perl mysql-client-4.1 mysql-common-4.1 mysql-server-4.1 libapache2-mod-php4 php4-cli php4-common php4-cgi php4-curl php4-mysql php4-pear python-soappy lsof cvs apache2 python2.1 ntpdate ntp-simple ssh
apt-get -y --force-yes --reinstall install python=2.1.3-3 python-soappy=0.9.7-3
apt-get -y remove python2.3

# Install mpck, a small program that'll analyze the audio files on the Digibuddy:
wget http://mpck.linuxonly.nl/mpck_0.10-1_i386.deb
dpkg -i mpck_0.10-1_i386.deb

# Set up some directories where the Digibuddy code will live:
mkdir /home/digibuddy/conf/
mkdir /home/digibuddy/conf/apc/
chown -R www-data /home/digibuddy/conf/
chgrp -R www-data /home/digibuddy/conf/
mkdir -m755 /usr/lib/cgi-bin/apc
chown -R www-data /usr/lib/cgi-bin/apc
chgrp -R www-data /usr/lib/cgi-bin/apc
mkdir /var/www/apc
chown -R www-data /var/www/apc
chgrp -R www-data /var/www/apc
mkdir /var/www/mirror
chown -R www-data /var/www/mirror
chgrp -R www-data /var/www/mirror
mkdir /var/www/affidavits/
chown -R www-data /var/www/affidavits
chgrp -R www-data /var/www/affidavits

# Go home
cd /home/digibuddy/

# Download and install the ICP program (icp-dcr-remote) that this server will run in order to talk to the local receiver:
wget http://spud.digiceiver.com/jazzworks-7102/apc/apc-20020214.tar.gz --http-user=user --http-passwd=****
tar -zxvf apc-20020214.tar.gz
cp apc/bin/* /usr/local/bin/.
cp apc/cgi/* /usr/lib/cgi-bin/.
chmod 755 /usr/lib/cgi-bin/apc/*
mkdir /usr/lib/python2.1/site-packages/digiceiver
cp apc/digiceiver/* /usr/lib/python2.1/site-packages/digiceiver/.
mkdir /usr/share/perl5/Digiceiver
cp apc/site_perl/Digiceiver/* /usr/share/perl5/Digiceiver/.
cp /usr/local/bin/icp-dcr-remote /etc/init.d/.
mkdir /var/local/icp/
mkdir /var/local/icp/run
chmod -R a+w /var/local/icp/run

# Get the script that contains instructions for installing the Digibuddy web site on this machine:
wget http://jazzworkscontrol.saturdavey.com/apc_branch_install.sh --http-user=user --http-passwd=****
#chmod 755 apc_install.sh
chmod 755 apc_branch_install.sh

# Set up the PYTHONPATH so icp-dcr-remote knows where to find Python
export PYTHONPATH=/usr/lib/python2.1/site-packages/SOAPpy:/usr/lib/python2.1/site-packages

# Create a link so icp-dcr-remote starts when the server is booted up:
cp /usr/local/bin/icp-dcr-remote /etc/init.d/.
cd /etc/rc2.d/
ln -s ../init.d/icp-dcr-remote S20icp-dcr-remote

# Set up this server's second NIC.  This NIC is not on the same address as the first, which creates a separate subnet 
# used only for communication between this Digibuddy and the 974(s) connected to this NIC:
#ifconfig eth1 192.168.210.99 netmask 255.255.255.0

echo "auto eth1" >> /etc/network/interfaces
echo "iface eth1 inet static" >> /etc/network/interfaces
echo "address 192.168.210.99" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
echo "network 192.168.210.0" >> /etc/network/interfaces

#Restart the networking on this machine so the above changes take effect:
/etc/init.d/networking restart

# Start icp-dcr-remote
/etc/init.d/icp-dcr-remote

# Go home
cd /home/digibuddy

# Get PEAR packages used by the Digibuddy website:
wget http://pear.php.net/get/Net_DIME-0.3.tgz http://pear.php.net/get/Net_Socket-1.0.6.tgz http://pear.php.net/get/SOAP-0.8RC3.tgz http://pear.php.net/get/HTTP_Request-1.3.0.tgz http://pear.php.net/get/DB-1.7.6.tgz
pear upgrade Net_Socket-1.0.6.tgz
pear install --force Net_DIME-0.3.tgz Mail_Mime Net_URL HTTP_Request-1.3.0.tgz SOAP-0.8RC3.tgz DB-1.7.6.tgz

# Enable mod_ssl
a2enmod ssl

# Enable mod_php4
a2enmod php4

# Enable mod_rewrite
a2enmod rewrite

# Log in to the local CVS server.  This script will stall at this point and require a user to enter a password
export CVSROOT=user@server.host.com:/cvs
export CVS_RSH=ssh
#cvs login

# Run the Digibuddy website installation script:
#/home/digibuddy/apc_install.sh createdb
/home/digibuddy/apc_branch_install.sh $1 createdb

# Now that we've (re)created /var/www/apc (using the apc_install.sh script we just called)
# we can build a link from /var/www/apc/mirror to /var/www/mirror (so the audio files are accessible 
# via this Digibuddy's website):
ln -s /var/www/mirror /var/www/apc/mirror

# Put a customized Apache configuration file into place:
mv /var/www/apc/conf/default /etc/apache2/sites-available/default
mv /var/www/apc/conf/ports.conf /etc/apache2/ports.conf
mv /var/www/apc/conf/apache2.conf /etc/apache2/apache2.conf

# Put into place the files required to operate the SSL server:
mv /var/www/apc/conf/apache.pem /etc/apache2/ssl/apache.pem

# Put a customized PHP ini file into place:
mv /var/www/apc/conf/php.ini /etc/php4/apache2/php.ini

# Put a customized config file file into place to manage the ntp daemon (to keep Digibuddy's clock accurate):
mv /var/www/apc/conf/ntp.conf /etc/ntp.conf

# One last try at assigning proper permissions to everything we moved
# into /usr/lib/cgi-bin/apc:
chmod a+x /usr/lib/cgi-bin/apc/*

# Restart the webserver so these customized files are read:
apache2ctl restart