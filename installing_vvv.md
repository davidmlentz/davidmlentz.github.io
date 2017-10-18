# Notes
From the original document, here.
Installing VVV
Overview
The objectives of the procedure described here are to 1) create a local WordPress installation where you can do development and design work and 2) contribute that work to the WordPress core project.

This process uses Vagrant, a "tool for building and distributing development environments.” Vagrant provides an environment that isn’t specific to WordPress (or any other application), so you’ll also use VVV, “an open source Vagrant configuration focused on WordPress development.”
Installing and Configuring VVV
Install Vagrant. Download Vagrant from this site and install it on your machine.
Install Virtualbox. Download VirtualBox from this site and install it on your machine.
Install Vagrant plugins. There are many plugins available to extend Vagrant’s functionality. To install a few useful for this procedure, type: vagrant plugin install vagrant-hostsupdater vagrant-triggers
Install VVV. Clone the VVV GitHub repo to install it on your machine. Type this command: git clone git://github.com/Varying-Vagrant-Vagrants/VVV.git vagrant-local
Launch VVV. Execute this command: cd vagrant-local && vagrant up. As this command runs, you’ll be prompted for a root password to allow VVV to make necessary changes to your hosts file.
Using your Local Development Environment
VVV is now running locally, which means you can access several versions of the WordPress application and the WordPress core source code. Click the links below to explore your VVV environment.
http://vvv.dev Your VVV home page. Links to local dev sites and admin tools.
http://local.wordpress.dev/ for WordPress stable
http://local.wordpress-trunk.dev/ for WordPress trunk. (TODO: this site does not come up.)
http://src.wordpress-develop.dev/ for trunk WordPress development files
http://build.wordpress-develop.dev/ for the version of those development files built with Grunt
You can use your IDE to change any of the files in the environment, developing features and bugfixes and testing them locally. To learn how to contribute your changes back to the WordPress project, see the next section.
Using GitHub to Contribute Changes to WordPress Core
You can create a GitHub repository to store your copy of the WordPress core source code. This is where you’ll commit any changes you make that you intend to contribute to the WordPress core project. Those changes must be associated with a Trac ticket and created in a feature branch named after the ticket's ID. 
Configuring your VVV instance
Switch Your VVV to Git. Your VVV instance includes an SVN repo; change it to Git: vagrant ssh -c develop_git
Create a GitHub repository. Create a new "wordpress-develop” repository in your GitHub account.
Set Your GitHub Origin. Set this new repo as your origin remote: cd www/wordpress-develop && git remote set-url origin https://github.com/YOURNAME/wordpress-develop.git && git remote add upstream git://develop.git.wordpress.org/
Contributing a feature or bug fix
Base your work on a Trac ticket. Find (or create) a Trac ticket describing the feature or bugfix you’ll work on.
Do your work in a feature branch. Create a feature branch for this ticket (e.g. 12345) in your GitHub "wordpress-develop” repository: git checkout -b trac-12345
Make your changes in VVV. Develop and test your feature or bugfix in your VVV clone.
Commit your changes. Commit your revised code to your GitHub "wordpress-develop” repository.
Create a pull request. Merge your commits into master from your feature branch.
Update the Trac ticket. Paste the URL of that pull request into the Trac ticket and attach the diff file corresponding to your pull request.
