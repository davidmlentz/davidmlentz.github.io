# Overview

# Prerequisites

You'll need a Datadog account. Visit datadoghq.com to log in, or to create a free account.

This assumes you have an ubuntu server configured as a LAMP stack. If you need to install the necessary 
packages, use:

`sudo apt-get update`

`sudo apt-get install -y apache2 mysql-server php libapache2-mod-php`

We'll need Composer for configuring PHP in the steps below, so install that, too. (Composer itself requires Curl, so...)

`sudo apt-get install -y composer php-curl`

# The Datadog Agent

The Datadog Agent runs on your host and is responsible for collecting metrics and sending data to Datadog so you can view it in your account.

## Installing the Agent

`DD_API_KEY=[your Datadog API key] bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"`

See also https://app.datadoghq.com/account/settings#agent/ubuntu

![here is an image](https://github.com/davidmlentz/davidmlentz.github.io/blob/master/1%20step%20install.png "One-step agent installation")

### Copy Agent Install String

[[https://github.com/davidmlentz/davidmlentz.github.io/blob/master/1%20step%20install.png|alt=installation]]

### Execute Agent Install String

### View Host Metrics on Datadog


(screenshot)

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

(screenshot)
apache.net.hits
https://app.datadoghq.com/metric/explorer

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

(screenshot)
mysql.performance.queries
https://app.datadoghq.com/metric/explorer

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

(screenshot)
functionCalls.count
https://app.datadoghq.com/metric/explorer

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

# Conclusion
(screenshot)
