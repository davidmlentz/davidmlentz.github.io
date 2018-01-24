# Overview

## What is the LAMP stack?

Web applications of any scale have some common requirements. Commonly, web apps run on a server (or group of servers) running web server software, a database and a server-side language. The LAMP stack--a combination of Linux, Apache, MySQL and PHP (or alternatively Python)--is one way to bring together the technologies required to power a scalable and dynamic web application. 

## Why is monitoring the LAMP stack important?

Datadog provides a platform for aggregating and displaying data that represent the performance of your infrastructure. Because your LAMP stack is the foundation of your application, your users' experience--and your business--rests on the performance of these servers. By bringing your LAMP stack's performance data into Datadog, you can visualize and communicate information that represents steady state performance, outages and incidents, scalability needs, and potential problems. That information should form the basis for your decisions as you maintain that app, and help you decide what changes to make in your application development and technology architecture.

## What you'll learn in this post

Collecting and dislpaying valuable, actionable data starts with a few small steps. This article will guide you through installing and configuring the Datadog Agent, and instrumenting some basic code to gather the type of data that can help you understand your application's performance.

# Prerequisites

## Datadog account
To perform the steps in this guide, you'll need a Datadog account. Visit to create a free account, or to log in if you already have one.

## LAMP server

This assumes you have an ubuntu server configured as a LAMP stack. (The steps written were executed on a virtual server running Ubuntu 16.04. These commands and sample code should work correctly on any similar Debian-based server. If you're using an RPM-based server, you'll need to make the necessary substitutions for the `apt-get` steps.) 

If you need to install the necessary packages, use:

Ensure that your package lists are up to date:
`sudo apt-get update`

Install Apache, MySQL and PHP:
`sudo apt-get install -y apache2 mysql-server php libapache2-mod-php`

We'll need Composer for configuring PHP in the steps below. Composer itself requires Curl, so install both of them:
`sudo apt-get install -y composer php-curl`

# Installing the Agent on your Linux Host

The Datadog Agent runs on your host and is responsible for collecting metrics and sending data to Datadog so you can view it in your account.

## What is the agent?

## Copy Agent Install String

Within your Datadog account, you can find an installation command that's customized for your use. This includes your API key, which is necessary to authorize the agent to send your data to your Datadog account.

Navigate to the [Agent Installation page](https://app.datadoghq.com/account/settings#agent/ubuntu) to see your unique agent installation string.

![One-step agent installation](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/1%20step%20install.png "One-step agent installation")

Copy this to your clipboard.

## Execute Agent Install String

At your Ubuntu command line, paste your customized agent installation string and hit enter. The agent will install itself and begin sending metrics to Datadog. The process will end with a pause while the agent confirms that initial metrics are being collected and sent successfully.

![Waiting for metrics]( "Waiting for metrics")

### View Host Metrics on Datadog

You'll notice the end of the installation process includes "Sending metrics..." (TODO)

(screenshot)

The Datadog agent has gone to work already sending data about your server into your Datadog account. Let's take a look:

The [infrastructure list](https://app.datadoghq.com/infrastructure) (TODO: host list?) in your Datadog account shows a list of your hosts that are being actively monitored by your Datadog account. Click the name of your first host to see the metrics the agent is now reporting.

![Host metrics](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Host%20Metrics.png "Host metrics")

There's not much here yet. Next we'll begin gathering metrics on the performance of your Apache server.

## Apache
 
### Configure the Agent

In the last step, you installed the Datadog agent on your LAMP server. Next you'll configure the agent to enable Apache integration:

`sudo cp /etc/dd-agent/conf.d/apache.yaml.example /etc/dd-agent/conf.d/apache.yaml`

Next, restart the agent so your changes take effect:
`sudo /etc/init.d/datadog-agent restart`

### Generate Sample Data

You can generate some metrics (page hits) with this command. (This will request a non-existent page on your server, and the resulting errors will be visible in your Datadog dashboard).

`for i in {1..99}; do wget http://localhost/404.html; done && rm 404.html*`

### View Apache Metrics on Datadog (default Apache dashboard)

Go to https://app.datadoghq.com/metric/explorer and type apache.net.hits in the Graph field.

![Metric Explorer for Apache](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20apache.net.hits.png "Metric Explorer for Apache")

## MySQL

### Configure the Agent

`CREATE USER 'datadog'@'localhost' IDENTIFIED BY 'mypassword';`

`GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'localhost' WITH MAX_USER_CONNECTIONS 5;`

`GRANT PROCESS ON *.* TO 'datadog'@'localhost';`

`GRANT SELECT ON performance_schema.* TO 'datadog'@'localhost';`

`FLUSH PRIVILEGES;`

`sudo cp /etc/dd-agent/conf.d/mysql.yaml.example /etc/dd-agent/conf.d/mysql.yaml`

`sudo vi /etc/dd-agent/conf.d/mysql.yaml`

...and edit the connection info in the mysql.yaml file (user, pass).

Next, restart the agent so your changes take effect:
`sudo /etc/init.d/datadog-agent restart`

### Generate Sample Data

You can generate some metrics with this command:
`for i in {1..99}; do mysql -u datadog --password=mypassword -e "select now();"; done`

### View MySQL Metrics on Datadog (default MySQL dashboard)

Go to https://app.datadoghq.com/metric/explorer and type mysql.performance.queries in the Graph field.

![Metric Explorer for MySQL](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20mysql.performance.queries.png "Metric Explorer for MySQL")

## PHP 

### Configure the Agent

Modify the agent to get PHP monitoring going (“Configure the agent to enable the PHP integration”)

 - install composer and php-curl
 - create index.php
 - generate php data


We'll build a simple web app in your server's document root. Move into your web app's document root:
`cd /var/www/html`

Configure the web app to use the Datadog PHP integration:
`composer require datadog/php-datadogstatsd`

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

### Generate Sample Data

You can generate some metrics with this command:
`for i in {1..99}; do wget http://localhost/index.php; done && rm index.php.*`

### View PHP Metrics on Datadog

Go to https://app.datadoghq.com/metric/explorer and type mysql.performance.queries in the Graph field.

![Metric Explorer for PHP](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/Metric%20Explorer%20functionTime.duration.avg.png "Metric Explorer for PHP")

# Viewing Data: Creating a Custom Dashboard in Datadog

At each step above, we've looked at Datadog's Metric Explorer to see some initial metrics. In this step, we'll create a custom dashboard, combining relevant metrics to help visualize the health of our LAMP server and the performance of our app.

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
