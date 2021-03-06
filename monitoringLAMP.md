# Monitoring the LAMP Stack with Datadog

## Overview

### What is the LAMP stack?

The LAMP stack&mdash;a combination of Linux, Apache, MySQL and PHP (or alternatively Python)&mdash;is one way to bring together the technologies required to power a scalable and dynamic web application. 

### Why is monitoring the LAMP stack important?

By bringing your LAMP stack's performance data into Datadog, you can visualize and communicate information that represents application performance, outages and incidents, scalability needs, and potential problems.

### What you'll learn in this post

This article guides you through installing and configuring the Datadog Agent and instrumenting some basic code to gather the type of data that can help you understand your application's performance.

Once the Agent is running, you'll view application data in Datadog's default dashboards. You'll finish by creating a basic customized dashboard that combines metrics from all components of your LAMP stack.

## Prerequisites

### Datadog account
To perform the steps in this guide, you'll need a Datadog account. See [https://www.datadoghq.com/](https://www.datadoghq.com/) to log in, or to create a free trial account.

### Datadog integrations
Within your Datadog account settings, you'll need to install integrations for the components of the LAMP stack to be monitored. 

Note: as you install each of these integrations, you'll see instructions on configuring and validating each installation. We'll go through those steps in detail below, so at this stage you can scroll to the bottom of the Configuration tab and click "Install Integration."

1. [Apache integration](https://app.datadoghq.com/account/settings#integrations/apache)
1. [MySQL integration](https://app.datadoghq.com/account/settings#integrations/mysql)
1. [PHP integration](https://app.datadoghq.com/account/settings#integrations/php)

### LAMP server

This guide assumes you have a LAMP stack running on a Ubuntu server. (The commands below were executed on Ubuntu 16.04. These commands and sample code should work correctly on any Debian-based server. If you're using an RPM-based server, you'll need to make the necessary substitutions for the `apt-get` steps.) 

If your Unbuntu server isn't already running Apache, MySQL, and PHP, follow these steps:

1. Update your package lists: `sudo apt-get update`
1. Install Apache, MySQL and PHP: `sudo apt-get install -y apache2 mysql-server php libapache2-mod-php`
1. Install Composer, which you'll need for configuring PHP to work with Datadog. Composer itself requires Curl, so install them both: `sudo apt-get install -y composer php-curl`

## Installing the Datadog Agent on a Linux host

The Agent runs on your host and is responsible for collecting metrics and sending data to your Datadog account.

### Copy the Agent installation string

Within your Datadog account, you can find an Agent installation command that's customized for your use. This includes your API key, which is necessary to authorize the Agent to send metrics to Datadog.

Navigate to the [Agent installation instructions](https://app.datadoghq.com/account/settings#agent/ubuntu) to see your unique Agent installation string.

![One-step agent installation](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/1%20step%20install_b.png "One-step agent installation")

Copy the Agent installation command (the string starting with "DD_API_KEY=") to your clipboard.

### Execute the Agent installation string

At your Ubuntu command line, paste the Agent installation command and hit enter. The Agent installs and begins sending metrics to Datadog. The process ends with a pause while the Agent confirms that initial metrics are being collected and sent successfully.

![Waiting for metrics](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Waiting%20for%20metrics_c.png "Waiting for metrics")

Once installation is verified, you'll see a message confirming that the Agent is functioning properly.

### View host metrics on Datadog

The [infrastructure list](https://app.datadoghq.com/infrastructure) in your Datadog account shows a list of hosts actively monitored by your Datadog account. Click the name of your first host to see the initial metrics.

![Host metrics](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Host%20Metrics.png "Host metrics")

This default dashboard displays the top-level metrics for each host running the Datadog agent. Next, you'll start gathering metrics on the performance of your Apache server.

## Getting started monitoring Apache
 
### Configure the Agent

The Agent installation script placed some example configuration files on your server. To begin collecting Apache metrics, copy the Apache example configuration file into place for the Agent to use:

`sudo cp /etc/dd-agent/conf.d/apache.yaml.example /etc/dd-agent/conf.d/apache.yaml`

Next, restart the Agent so your changes take effect:
`sudo /etc/init.d/datadog-agent restart`

### Generate sample data

You can generate some Apache metrics with the following command:

`for i in {1..99}; do wget http://localhost/404.html; done && rm 404.html*`

### View Apache metrics in Datadog 

Navigate to Datadog's [default Apache dashboard](https://app.datadoghq.com/screen/integration/19/apache).

![Default Apache Dashboard](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Default%20apache%20dashboard_2.png "Default Apache Dashboard")

The graphs should show data corresponding to the `wget` command you executed above. If you don't see any data, you may need to enable Apache's status module, mod_status. See [How to collect Apache performance metrics](https://www.datadoghq.com/blog/collect-apache-performance-metrics/#apache-s-status-module) for more information about mod_status.

## Getting started monitoring MySQL

### Configure the Agent

To get information about your LAMP stack's database server performance, configure the Agent to report MySQL metrics. 

Note: the commands below contain a placeholder password&mdash;`<mypassword>`&mdash;which you should replace with an appropriate password to use with your Datadog MySQL user account.

First, connect to my MySQL as the root user and execute these queries:

`CREATE USER 'datadog'@'localhost' IDENTIFIED BY '<mypassword>';`

`GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'localhost' WITH MAX_USER_CONNECTIONS 5;`

`GRANT PROCESS ON *.* TO 'datadog'@'localhost';`

`GRANT SELECT ON performance_schema.* TO 'datadog'@'localhost';`

`FLUSH PRIVILEGES;`

Next, copy the MySQL example configuration file into place for the Agent to use:

`sudo cp /etc/dd-agent/conf.d/mysql.yaml.example /etc/dd-agent/conf.d/mysql.yaml`

Then edit the file to update connection information so the Agent can connect to the database:

`sudo vi /etc/dd-agent/conf.d/mysql.yaml`

Update the `user` and `pass` values in this file to reflect the user and password from the SQL statements above.

![MySQL configuration](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/MySQL%20config_1.png "MySQL configuration")

Next, restart the Agent so your changes take effect:
`sudo /etc/init.d/datadog-agent restart`

The Datadog Agent is now collecting data about your MySQL server's performance.

### Generate sample data

You can generate some MySQL metrics with this command:

`for i in {1..99}; do mysql -u datadog --password=<mypassword> -e "select now();"; done`

### View MySQL metrics in Datadog

To see how Datadog displays the metrics you just generated, navigate to the [default MySQL dashboard](https://app.datadoghq.com/dash/integration/12/).

![Default MySQL Dashboard](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Default%20mysql%20dashboard_2.png "Default MySQL Dashboard")

## Getting started monitoring PHP 

Using the Datadog PHP library, you can measure application performance indicators&mdash;such as page loads and function speed&mdash;by strategically adding a small amount of code to your PHP files.

### Create a simple PHP application

To start reporting PHP metrics, create a simple PHP app that requires the Datadog PHP library.

1. Move into your LAMP server's web document root: `cd /var/www/html`
1. Configure the web app to use the Datadog PHP library: `composer require datadog/php-datadogstatsd` (Note: if you receive an error on this step, Composer may not be installed on your server. Execute this command to install Composer on an Ubuntu host: `sudo apt-get install -y composer php-curl`)
1. Create a PHP file: `vi index.php`
1. Paste this sample code into index.php:

PHP sample code:
```php
<?php
  require __DIR__ . '/vendor/autoload.php';
 
  use DataDog\DogStatsd;
  $statsd = new DogStatsd();

  function functionTime() {
    // Simulate time required to run a function:
    usleep(rand(0,100000));
  }

  function functionCalls() {
    global $statsd;
    $statsd->increment('functionCalls.count');
  }

  $start_time = microtime(true);
  functionTime();
  $statsd->timing('functionTime.duration', microtime(true) - $start_time);

  functionCalls();
  
  echo "Hello world";
?>
```
The Datadog Agent is now ready to collect and report data about your PHP application.

### Generate sample data

Generate some metrics by simulating web traffic with this command:

`for i in {1..99}; do wget http://localhost/index.php; done && rm index.php.*`

### View PHP metrics in Datadog

Navigate to Datadog's [Metric Explorer](https://app.datadoghq.com/metric/explorer) and type `functionTime.duration.avg` in the Graph field.

![Metric Explorer for PHP](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20functionTime.duration.avg_2.png "Metric Explorer for PHP")

To learn more about collecting PHP metrics, see the [PHP DataDog StatsD Client on GitHub.](https://github.com/DataDog/php-datadogstatsd)

## Creating a custom dashboard in Datadog

A custom dashboard lets you combine whatever metrics are necessary to help visualize the overall performance of your application and its infrastructure.

In [your Datadog account](https://app.datadoghq.com), click "Dashboards" in the left-side navigation, then click "New Dashboard." Type a title for your dashboard in the "Dashboard Name" field, then click the "New TimeBoard" button. (The other option here is to create a ScreenBoard. For information on these two types of dashboards, see [this FAQ article](https://help.datadoghq.com/hc/en-us/articles/204580349-What-is-the-difference-between-a-ScreenBoard-and-a-TimeBoard-).)

Follow these steps to add graphs to your timeboard to display information about your LAMP application.

1. Drag the Timeseries widget onto the board
1. Under "Choose metrics and events," change the "Get" value to "apache.net.hits" and click "Save."

Repeat the steps above to add three other Timeseries widgets, replacing the "Get" value with the following:
1. "mysql.performance.queries"
1. "functionCalls.count"
1. "functionTime.duration.avg"

The resulting custom dashboard should look like this:

![Custom Datadog Dashboard](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/My%20dashboard_2.png "Custom Datadog Dashboard")

You can continue to customize this dashboard by adding any widgets you feel might be useful. To save your customized dashboard, click the "Finish Editing" button at the top of the page.

## Conclusion

In this short tutorial, you've installed the Datadog Agent on your LAMP host, added Datadog integrations for the LAMP stack, and created a custom dashboard to view application metrics.

The simple examples here demonstrate how to use Datadog to monitor the LAMP stack. As the complexity of your app grows, you can extend these examples to your growing codebase and infrastructure.

Sign up for a free Datadog trial account at [https://www.datadoghq.com](https://www.datadoghq.com).
