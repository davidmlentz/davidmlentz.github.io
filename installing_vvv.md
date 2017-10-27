# Notes
From the original document, [here](https://make.wordpress.org/core/handbook/tutorials/installing-a-local-server/installing-vvv/).

# Overview
## What is HelpHub
HelpHub ([wp-helphub.com](https://wp-helphub.com/)) is the online manual for WordPress. It replaces the WordPress Codex. HelpHub is created and maintained by volunteer contributors, and your contributions are welcomed. This document describes the ways which you can contribute. See [Contributing to the Docs Team](https://github.com/Kenshino/HelpHub/blob/master/CONTRIBUTING.md) for more information on contributing to HelpHub.

# Contributing Content
HelpHub is a living repository of articles and guides, publicly available at [wp-helphub.com](https://wp-helphub.com/). The information there is created and maintained by WordPress community members who volunteer to write, edit and maintain topics designed to help WordPress users at all levels. Writing content for HelpHub is an opportunity to make WordPress more useful to the community.


## Access to the Site
To gain access as a HelpHub author or editor, visit https://wordpress.slack.com/ and send a message to @kenshino requesting an account.

## Style
Follow the [Handbooks Style and Formatting Guide](https://make.wordpress.org/docs/handbook/developer-resources/handbooks/handbooks-style-and-formatting-guide/) to make your HelpHub content as usable as possible.

# Contributing Code
Like any other website, HelpHub requires design and development work. Your contributions in these areas can assure that HelpHub is as performant and usable as possible. 

To facilitate the work of many volunteer developers, HelpHub uses [Varying Vagrant Vagrants (VVV)](https://varyingvagrantvagrants.org/) so developers can easily create a local WordPress environment. Follow the steps in this section to create your development environment and contribute code to the HelpHub project.

## Installing VVV
### Overview
The objectives of the procedure described here are to 1) create a local WordPress installation where you can do development and design work and 2) contribute that work to the HelpHub project.

This process uses [Vagrant](https://www.vagrantup.com/), which allows you to create a sandboxed development environment on your computer. Vagrant provides an environment that isn’t specific to WordPress (or any other application), so you’ll also use [VVV](https://varyingvagrantvagrants.org/) to configure your Vagrant environment specifically for WordPress development.
### Installing and Configuring VVV
1. **Install Vagrant.** [Download Vagrant from this site](https://www.vagrantup.com/downloads.html) and install it on your machine.
1. **Install Virtualbox.** [Download VirtualBox from this site](https://www.virtualbox.org/wiki/Downloads) and install it on your machine.
1. **Install Vagrant plugins.** There are many plugins available to extend Vagrant’s functionality. To install a few that will be useful below, type: `vagrant plugin install vagrant-hostsupdater vagrant-triggers`.
1. **Install VVV.** Clone the VVV GitHub repo to install it on your machine. Type this command: `git clone git://github.com/Varying-Vagrant-Vagrants/VVV.git vagrant-local`.
1. **Launch VVV.** Execute this command: `cd vagrant-local && vagrant up`. As this command runs, you’ll be prompted for a root password to allow VVV to make necessary changes to your hosts file.
### Using Your Local Development Environment
VVV is now running locally, which means you can access several versions of the WordPress application and the WordPress core source code. Click the links below to explore your VVV environment.
+ [http://vvv.dev] Your VVV home page. Links to local dev sites and admin tools.
+ [http://local.wordpress.dev/] for WordPress stable.
+ [http://local.wordpress-trunk.dev/] for WordPress trunk.
+ [http://src.wordpress-develop.dev/] for trunk WordPress development files.
+ [http://build.wordpress-develop.dev/] for the version of those development files built with Grunt.

You can use your IDE to change any of the files in the environment, developing features and bugfixes and testing them locally. To learn how to contribute your changes back to the WordPress project, see the next section.

<!---
### Using GitHub to Contribute Changes to WordPress Core
You can create a GitHub repository to store your copy of the WordPress core source code. This is where you’ll commit any changes that you intend to contribute to the WordPress core project. Those changes must be associated with a Trac ticket and created in a feature branch named after the ticket's ID. 
#### Configuring Your VVV Instance
1. **Switch Your VVV to Git.** Your VVV instance includes an SVN repo; change it to Git: `vagrant ssh -c develop_git`.
1. **Create a GitHub repository.** Create a new repository in your GitHub account named "wordpress-develop.”
1. **Set Your GitHub Origin.** Set this new repo as your origin remote: `cd www/wordpress-develop && git remote set-url origin https://github.com/YOURNAME/wordpress-develop.git && git remote add upstream git://develop.git.wordpress.org/`.
#### Contributing a Feature or Bugfix
1. **Base your work on a Trac ticket.** Find (or create) a Trac ticket describing the feature or bugfix you’ll work on.
1. **Do your work in a feature branch.** Create a feature branch for this ticket in your GitHub "wordpress-develop” repository. For example, if you're working on ticket 12345, type the command `git checkout -b trac-12345`.
1. **Make your changes in VVV.** Develop and test your feature or bugfix in your VVV clone.
1. **Commit your changes.** Commit your revised code to your GitHub "wordpress-develop” repository.
1. **Create a pull request.** Merge your commits into master from your feature branch.
1. **Update the Trac ticket.** Paste the URL of that pull request into the Trac ticket and attach the diff file corresponding to your pull request.
--->

### Using GitHub to Contribute Design and Development to HelpHub
If you’re interested in contributing to HelpHub as a developer, you can assign yourself an [issue from the GitHub repo](https://github.com/Kenshino/HelpHub/issues) and contribute code to fix a bug or add a feature.
1. **Fork the project.** Create a fork of the HelpHub source code from https://github.com/Kenshino/HelpHub. This fork is where you’ll commit any changes that you intend to contribute to the HelpHub project. (Note: the process for contributing content is different. See "Contributing Content," above.)
1. **Create a local environment.** See "Installing and Configuring VVV," above.
1. **Empty wp-content.** In your development environment, remove all files from wp-content: `cd wp-content && rm -rf *`
1. **Clone your fork locally.** Within wp-content, clone your fork of the HelpHub repo: `git clone https://github.com/[githubusername]/HelpHub.git`
1. **Import the HelpHub data.** HelpHub's source code includes a database export (helphub.wordpress.2017-06-15.xml). Import this data into your local WordPress site to add a snapshot of the content.
1. **Make your changes in VVV.** Develop and test your feature or bugfix in your VVV clone.
1. **Commit your changes.** Commit your revised code to your HelpHub fork.
1. **Create a pull request.** Request to merge your commits into the HelpHub repo from your fork.

#### Development guidelines
To make the site usable, and to keep our codebase manageable, we're committed to these guidelines and standards.

1. **Accessibility**  HelpHub should be usable by all, including users with physical and cognitive disabilities, and those using assistive technologies. Our work must not create any obstacles or limit the access of these users. We embrace tools and processes that facilitate creating an accessible HelpHub, and we value design and testing that maximize accessiblity.

1. **Responsive Design**  We're committed to designing, building and maintaining a site that is usable on devices of varying sizes and platforms.

1. **Standardized Code** We adhere to the [WordPress Coding Standards](https://codex.wordpress.org/WordPress_Coding_Standards). We aim to create code that is consistent and readable. The HTML, CSS, PHP and Javascript created by the WordPress community should always follow the appropriate coding standard.
 
# Contributing to the discussion
WordPress is a community-driven project, and we encourage you to join the discussion to help innovate and prioritize. There are several ways you can contribute.
1. **Find bugs and create issues.** Like any website, HelpHub has bugs. You can help by investigating bugs and reporting them as [issues in the GitHub repository](https://github.com/Kenshino/HelpHub/issues).
1. **Propose design suggestions and improvements.** Submit your ideas as [GitHub issues](https://github.com/Kenshino/HelpHub/issues), and join the docs team discussion to help refine and prioritize pending work.
