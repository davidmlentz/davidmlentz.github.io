# Overview

## What is the LAMP stack?

Web applications of any scale have some common requirements. Web apps run on a server (or group of servers) running web server software, and usually a database and a server-side language. The LAMP stack--a combination of Linux, Apache, MySQL and PHP (or alternatively Python)--is one way to bring together the technologies required to power a scalable and dynamic web application. 

## Why is monitoring the LAMP stack important?

Because your LAMP stack is the foundation of your application, your users' experience--and your business--rests on the performance of these servers. Datadog provides a platform for aggregating and displaying data that represent your infrastructure's performance. By bringing your LAMP stack's performance data into Datadog, you can visualize and communicate information that represents steady state performance, outages and incidents, scalability needs, and potential problems. That information should form the basis for your decisions as you maintain that app, and help you decide what changes to make in your application development and technology architecture.

## What you'll learn in this post

Collecting and displaying valuable, actionable data starts with a few small steps. This article will guide you through installing and configuring the Datadog Agent, and instrumenting some basic code to gather the type of data that can help you understand your application's performance.

Once the Agent is running and the host is configured, you'll see how to look at the data displayed in your Datadog account. You'll see some default dashboards first, then finish by creating a basic customized dashboard combining the metrics from the various components of your LAMP stack.

# Prerequisites

## Datadog account
To perform the steps in this guide, you'll need a Datadog account. Visit [https://www.datadoghq.com/](https://www.datadoghq.com/) to create a free account, or to log in if you already have one.

## LAMP server

This assumes you have an Ubuntu server configured as a LAMP stack. (The commands below were executed on a virtual server running Ubuntu 16.04. These commands and sample code should work correctly on any similar Debian-based server. If you're using an RPM-based server, you'll need to make the necessary substitutions for the `apt-get` steps.) 

If your Unbuntu server isn't already running Apache, MySQL, and PHP, follow these steps:

Ensure that your package lists are up to date:
`sudo apt-get update`

Install Apache, MySQL and PHP:
`sudo apt-get install -y apache2 mysql-server php libapache2-mod-php`

Install Composer. You'll need this for configuring PHP. Composer itself requires Curl, so install both of them:
`sudo apt-get install -y composer php-curl`

# Installing the Agent on Your Linux Host

The Datadog Agent runs on your host and is responsible for collecting metrics and sending data to Datadog so you can view it in your account.

## Copy the Agent Installation String

Within your Datadog account, you can find an Agent installation command that's customized for your use. This includes your API key, which is necessary to authorize the agent to send your data to your Datadog account.

Navigate to the [Agent Installation page](https://app.datadoghq.com/account/settings#agent/ubuntu) to see your unique agent installation string. (Notice the different platforms listed on the left side of the page. As you add infrastructure of various types, this page will create the appropriate installation command for each of them.)

![One-step agent installation](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/1%20step%20install.png "One-step agent installation")

Copy the Agent installation command (the string starting with "DD_API_KEY=") to your clipboard.

## Execute Agent Install String

At your Ubuntu command line, paste the Agent installation command and hit enter. The Agent will install and begin sending metrics to Datadog. The process will end with a pause while the agent confirms that initial metrics are being collected and sent successfully.

![Waiting for metrics](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/waiting%20for%20metrics.png "Waiting for metrics")

Once installation is verified, you'll see a message confirming that the agent has launched successfully.

![Your agent is running and functioning properly](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/your%20agent%20is%20running.png "Your agent is running and functioning properly")

### View Host Metrics on Datadog

The Datadog agent has gone to work already sending data about your server into your Datadog account. Let's take a look:

The [host list](https://app.datadoghq.com/infrastructure) in your Datadog account shows a list of your hosts that are being actively monitored by your Datadog account. Click the name of your first host to see the initial metrics.

![Host metrics](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Host%20Metrics.png "Host metrics")

There's not much to see here yet, but this default dashboard displays the top-level metrics for each host running the Datadog agent. The following steps will guide you to start gathering metrics on the performance of your Apache server.

## Apache
 
### Configure the Agent

The Datadog agent is now running on the LAMP host and collecting top-level metrics. Next you'll configure the Agent to enable Apache integration so you can see data about your web server's performance:

When the agent installed, it included some example configuration files. Copy the Apache example into place for the agent to use:
`sudo cp /etc/dd-agent/conf.d/apache.yaml.example /etc/dd-agent/conf.d/apache.yaml`

Next, restart the agent so your changes take effect:
`sudo /etc/init.d/datadog-agent restart`

### Generate Sample Data

You can generate some Apache metrics with the following command. This will request a non-existent page on your server, but the requests will be visible in your Datadog dashboard.

`for i in {1..99}; do wget http://localhost/404.html; done && rm 404.html*`

### View Apache Metrics on Datadog 

The Datadog Agent is now collecting data about your web server's performance and sending it to your Datadog account. Let's take a look. Navigate to Datadog's [Metric Explorer](https://app.datadoghq.com/metric/explorer) and type `apache.net.hits` in the Graph field.

![Metric Explorer for Apache](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20apache.net.hits.png "Metric Explorer for Apache")

## MySQL

### Configure the Agent

To get information about your LAMP stack's database server performance, configure the agent to enable MySQL integration. (Note: the commands below contain a placeholder password--<mypassword>--which you should replace with an appropriate password to use with your Datadog MySQL user account.)

First, connect my MySQL as the root user and execute these queries:

`CREATE USER 'datadog'@'localhost' IDENTIFIED BY '<mypassword>';`

`GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'localhost' WITH MAX_USER_CONNECTIONS 5;`

`GRANT PROCESS ON *.* TO 'datadog'@'localhost';`

`GRANT SELECT ON performance_schema.* TO 'datadog'@'localhost';`

`FLUSH PRIVILEGES;`

Next, copy the Agent's MySQL configuration file into place:

`sudo cp /etc/dd-agent/conf.d/mysql.yaml.example /etc/dd-agent/conf.d/mysql.yaml`

Then edit the file to update connection information so the Agent can connect to the database:

`sudo vi /etc/dd-agent/conf.d/mysql.yaml`

Update the Database section of this file to reflect the user and password from the SQL statements above.

Next, restart the agent so your changes take effect:
`sudo /etc/init.d/datadog-agent restart`

The Datadog Agent is now collecting data about your MySQL server's performance and sending it to your Datadog account.

### Generate Sample Data

You can generate some MySQL metrics with this command:
`for i in {1..99}; do mysql -u datadog --password=<mypassword> -e "select now();"; done`

### View MySQL Metrics on Datadog

To see how Datadog displays the metrics you just generated, navigate to the [Metric Explorer](https://app.datadoghq.com/metric/explorer) and type `mysql.performance.queries` in the Graph field.

![Metric Explorer for MySQL](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20mysql.performance.queries.png "Metric Explorer for MySQL")

## PHP 

### Configure the Agent

You'll create a simple PHP app. 
You'll include code to add the Datadog PHP client to the app.
Then you'll add some PHP code to collect and report metrics about the app's performance.

First, move into your LAMP server's web document root:
`cd /var/www/html`

Configure the web app to use the Datadog PHP integration:
`composer require datadog/php-datadogstatsd`

If you receive an error on this step, it could be that Composer hasn't been installed on your server. Execute this command to install Composer on an Ubuntu host:
`sudo apt-get install -y composer php-curl`

Create a PHP file by pasting the sample code, below:
`vi index.php`

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
The Datadog agent is now ready to collect and report data about your simple PHP application.

### Generate Sample Data

Generate some metrics by simulating web traffic with this command:
`for i in {1..99}; do wget http://localhost/index.php; done && rm index.php.*`

### View PHP Metrics on Datadog

To view the PHP application data you've generated, navigate to Datadog's [Metric Explorer](https://app.datadoghq.com/metric/explorer) and type `functionTime.duration.avg` in the Graph field.

![Metric Explorer for PHP](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20functionTime.duration.avg.png "Metric Explorer for PHP")

# Viewing Data: Creating a Custom Dashboard in Datadog

The steps above have used Datadog's Metric Explorer to see some initial metrics. Intead of looking at each of these separately, you can create a custom dashboard, combining relevant metrics to help visualize the performance the infrastructure and the application.

1. Dashboards
1. New Dashboard
1. Dashboard Name = "My Dashboard"
1. New TimeBoard

1. Drag the Timeseries widget onto the board
1. Select your visualization: Leave as Timeseries
1. Choose metrics and events: Change "Get" value to apache.net.hits and click Save
1. Repeat these steps, but use mysql.performance.queries as the "Get" value
1. Repeat these steps, but use functionCalls.count as the "Get" value
1. Repeat these steps, but use functionTime.duration.avg as the "Get" value

![Custom Datadog Dashboard](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/My%20Dashboard.png "Custom Datadog Dashboard")

# Conclusion
(screenshot)
