# Monitoring LAMP

## Overview

This article will…

The LAMP stack is…

Monitoring the LAMP stack is important because…

The things you’ll need to do are…

What metrics are important? What are the key performance metrics we’ll look at? Are there types or categories of metrics?

## Prerequisites

This assumes you have an ubuntu server configured as a LAMP stack. If you need to install the necessary 
packages, use:

`apt-get update`

`apt-get install -y apache2 mysql-server php libapache2-mod-php`

We'll need Composer for configuring PHP in the steps below, so install that, too. (Composer itself requires Curl, so...)

`apt-get install -y composer php-curl`

## Linux
### on the server side...
Install the agent

`DD_API_KEY=[your Datadog API key] bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"`

See also https://app.datadoghq.com/account/settings#agent/ubuntu

### on the Datadog side...

See https://app.datadoghq.com/infrastructure 


## Apache
### on the server side...

In the last step, you installed the Datadog agent on your LAMP server. Next you'll configure the agent to enable Apache integration:

`cp /etc/dd-agent/conf.d/apache.yaml.example /etc/dd-agent/conf.d/apache.yaml`

Next, restart the agent so your changes take effect.

You can generate some metrics (page hits) with this command. (This will request a non-existent page on your server, and the resulting errors will be visible in your Datadog dashboard).
`for i in {1..50}; do wget http://localhost/404.html; done && rm 404.html*`

### on the Datadog side...

See (https://app.datadoghq.com/account/settings#integrations/apache)[https://app.datadoghq.com/account/settings#integrations/apache]


## MySQL
### on the server side...
Get MySQL monitoring going:
`CREATE USER 'datadog'@'localhost' IDENTIFIED BY '<UNIQUEPASSWORD>’;`

### on the Datadog side...


## PHP
### on the server side...
Modify the agent to get PHP monitoring going
(“Configure the agent to enable the PHP integration” ?)
https://docs.datadoghq.com/integrations/php/

PHP server commands:
`cd /var/www/html`
`composer require datadog/php-datadogstatsd``
`vi index.php`

PHP sample code:
```php
<?php
  require __DIR__ . '/vendor/autoload.php';
 
  use DataDog\DogStatsd;
  $statsd = new DogStatsd();

  function queryTime() {
    // Simulate time required for a db query:
    usleep(rand(0,100000));
  }

  function pageHits() {
    global $statsd;
    $statsd->increment('query.count');
  }

  $start_time = microtime(true);
  queryTime();
  $statsd->timing('queryTime.duration', microtime(true) - $start_time);

  pageHits();
  
  echo "Hello world";
?>
```

### on the Datadog side...
