# Notes
From the original document, [here](https://make.wordpress.org/core/handbook/tutorials/installing-a-local-server/installing-vvv/).

# Installing VVV
## Overview
The objectives of the procedure described here are to 1) create a local WordPress installation where you can do development and design work and 2) contribute that work to the WordPress core project.

This process uses [Vagrant](https://www.vagrantup.com/), which allows you to create a sandboxed development environment on your computer. Vagrant provides an environment that isn’t specific to WordPress (or any other application), so you’ll also use [VVV](https://varyingvagrantvagrants.org/) to configure your Vagrant environment specifically for WordPress development.
## Installing and Configuring VVV
1. **Install Vagrant.** [Download Vagrant from this site](https://www.vagrantup.com/downloads.html) and install it on your machine.
1. **Install Virtualbox.** [Download VirtualBox from this site](https://www.virtualbox.org/wiki/Downloads) and install it on your machine.
1. **Install Vagrant plugins.** There are many plugins available to extend Vagrant’s functionality. To install a few useful for this procedure, type: `vagrant plugin install vagrant-hostsupdater vagrant-triggers`
1. **Install VVV.** Clone the VVV GitHub repo to install it on your machine. Type this command: `git clone git://github.com/Varying-Vagrant-Vagrants/VVV.git vagrant-local`
1. **Launch VVV.** Execute this command: `cd vagrant-local && vagrant up`. As this command runs, you’ll be prompted for a root password to allow VVV to make necessary changes to your hosts file.
## Using your Local Development Environment
VVV is now running locally, which means you can access several versions of the WordPress application and the WordPress core source code. Click the links below to explore your VVV environment.
+ [http://vvv.dev] Your VVV home page. Links to local dev sites and admin tools.
+ [http://local.wordpress.dev/] for WordPress stable
+ [http://local.wordpress-trunk.dev/] for WordPress trunk. (TODO: this site does not come up.)
+ [http://src.wordpress-develop.dev/] for trunk WordPress development files
+ [http://build.wordpress-develop.dev/] for the version of those development files built with Grunt

You can use your IDE to change any of the files in the environment, developing features and bugfixes and testing them locally. To learn how to contribute your changes back to the WordPress project, see the next section.
## Using GitHub to Contribute Changes to WordPress Core
You can create a GitHub repository to store your copy of the WordPress core source code. This is where you’ll commit any changes you make that you intend to contribute to the WordPress core project. Those changes must be associated with a Trac ticket and created in a feature branch named after the ticket's ID. 
## Configuring your VVV instance
1. **Switch Your VVV to Git.** Your VVV instance includes an SVN repo; change it to Git: vagrant ssh -c develop_git
1. **Create a GitHub repository.** Create a new "wordpress-develop” repository in your GitHub account.
1. **Set Your GitHub Origin.** Set this new repo as your origin remote: cd www/wordpress-develop && git remote set-url origin https://github.com/YOURNAME/wordpress-develop.git && git remote add upstream git://develop.git.wordpress.org/
## Contributing a feature or bug fix
1. **Base your work on a Trac ticket.** Find (or create) a Trac ticket describing the feature or bugfix you’ll work on.
1. **Do your work in a feature branch.** Create a feature branch for this ticket (e.g. 12345) in your GitHub "wordpress-develop” repository: `git checkout -b trac-12345`
1. **Make your changes in VVV.** Develop and test your feature or bugfix in your VVV clone.
1. **Commit your changes.** Commit your revised code to your GitHub "wordpress-develop” repository.
1. **Create a pull request.** Merge your commits into master from your feature branch.
1. **Update the Trac ticket.** Paste the URL of that pull request into the Trac ticket and attach the diff file corresponding to your pull request.
