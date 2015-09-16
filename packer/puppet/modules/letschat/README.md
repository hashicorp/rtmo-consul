# letschat

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with letschat](#setup)
    * [What letschat affects](#what-letschat-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with letschat](#beginning-with-letschat)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Class: letschat](#classletschat)
    * [Class: letschat::app](#classletschatapp)
    * [Class: letschat::db](#classletschatdb)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Additional Information](#Additional-Information)

## Overview

This module deploys a self-hosted chat app for small teams, [Let's Chat](http://sdelements.github.io/lets-chat/).

![Screenshot of application](http://sdelements.github.io/lets-chat/assets/img/devices.png)

*This module has only been tested on Ubuntu 12.04 and 14.04*

## Module Description
The **letschat** module simplifies the configuration and deployment process of [Let's Chat](http://sdelements.github.io/lets-chat/),
by managing configuration for both the web application and the backend. This chat service is ideal for users who would like to host their own chat application that is hosted internally
or hosted externally, or can be used simply in a scorched earth scenario, where one's normal hosted chat application
is not accessible.

This module helps simplify the configuration of MongoDB, allowing the user to create a new database, the user account for
the web application to access the database, and configure the Node.js web application to suit the users needs by exposing most of the available
configuration found in the [Let's Chat Configuration Reference](https://github.com/sdelements/lets-chat/wiki/Configuration).


## Setup

### What letschat affects

* Creates letschat service: /etc/init.d/letschat
* MongoDB (2.6+) server and client packages and services
* The Let's Chat Node.js Application and associated configuration
* The installation of Node.js (0.10+) and npm packages and dependencies


### Beginning with letschat

To install letschat with default parameters

```
class letschat { }
```
*Please note that this install the web application and the database on the same
host*

To install and configure MongoDB backend with default parameters on a node:

```
class letschat::db {}
```

To install and configure just the letschat Node.js application with default parameters on a node:

```
class letschat::app {}
```

### Configuring MongoDB
To configure MongoDB and create a new database:
```
class { 'letschat::db':
  user          => 'lcadmin',
  pass          => 'unsafepassword',
  bind_ip       => '0.0.0.0',
  database_name => 'letschat',
  database_port => '27017',
}
```

### Configuring letschat
To configure Let's Chat and specify database settings:
```
class { 'letschat::app':
    dbuser          => 'lcadmin',
    dbpass          => 'unsafepassword',
    dbname          => 'letschat',
    dbhost          => 'dbserver0',
    dbport          => '27017',
    cookie          => 'thistest',
    deploy_dir      => '/etc/letschat',
    http_enabled    => true,
    lc_bind_address => '0.0.0.0',
    http_port       => '5000',
    ssl_enabled     => false,
    cookie          => 'secret',
    authproviders   => 'local',
    registration    => true,
}
```

## Usage

### Classes
This module contains 4 classes. The `letschat` class configures both MongoDB and the
web application with the values set in the `letschat::params` class. The `letschat::db` class configures
MongoDB in very limited scope by wrapping the MongoDB module. The `letschat::app` class is used for configuring
the Node.js application, specifying which features to enable, their settings, and specifying configuration so
the web application can reach the MongoDB backend.

#### Class:`letschat`
The `letschat` class configures both MongoDB and the
web application. This class is a basic include of the `letschat:app` and `letschat::db` class with the all parameters sourced from the `letschat::params` class.

#### Class:`letschat::app`
The `letschat::app` class is used for configuring
the Node.js application, specifying which features to enable, their settings, and specifying configuration so
the web application can reach the MongoDB backend.
##### Parameters within `letschat::app`:
####`deploy_dir`
The directory to deploy the Let's Chat application to. Defaults to '/etc/letschat'
####`http_enabled`
Boolean to specify whether http is enabled. Defaults to 'true'
####`http_port`
Port for Let's Chat to serve http traffic on. Defaults to '5000'
####`lc_bind_address`
Configured Let's Chat process to bind to and listen for connections from users on this address. Defaults to '0.0.0.0'
####`ssl_enabled`
Boolean to specify whether ssl is enabled. Defaults to 'false'
####`ssl_port`
Port for Let's Chat to serve https traffic on. Defaults to '5001'
####`ssl_key`
Path to SSL key. Defaults to 'key.pem'
####`ssl_cert`
Path to SSL certificate. Defaults to 'certificate.pem'
####`xmpp_enabled`
Boolean to specify whether xmpp is enabled. Defaults to 'false'
####`xmpp_port`
Port for Let's Chat to serve xmpp traffic on. Defaults to '5222'
####`xmpp_domain`
Domain for xmpp connections. Defaults to 'example.com'
####`dbuser`
Database username for accessing MongoDB Let's Chat Database. Defaults to 'lcadmin'
####`dbpass`
Database password (plain-text) for accessing MongoDB Let's Chat Database. Defaults to 'changeme'
####`dbhost`
Hostname of MongoDB server. Defaults to 'localhost'
####`dbname`
Database name of the Let's Chat Database. Defaults to 'letschat'
####`dbport`
Port number that MongoDB is listening on. Defaults to '27017'
####`cookie`
Cookie. Defaults to 'secretsauce'
####`authproviders`
Array of authentication providers for authenticating with Let's Chat. Accepts the following values: `local`, `kerberos`, and `ldap`.
Defaults to 'local'
####`registration`
Boolean to determine if new users can signup to Let's Chat. Defaults to 'true'


#### Class:`letschat::db`
The `letschat::db` class configures MongoDB in very limited scope by wrapping the MongoDB module.
##### Parameters within `letschat::app`:
####`user`
Name of the user for database. Defaults to 'lcadmin'
####`pass`
Plain-text user password (will be hashed). Defaults to 'changeme'
####`bind_ip`
This setting can be used to configure MonogDB process to bind to and listen for connections from applications on this address.
Defaults to '0.0.0.0'.
####`database_name`
This setting is used to configure the name of the MongoDB database. Defaults to 'letschat'
####`database_port`
Specifies a TCP port for the server instance to listen for client connections. Defaults to '27017'

## Limitations

This module has only been tested on Ubuntu 12.04 and 14.04. At this point in time only a limited number of parameters are exposed with regards to both the Node.js application and MongoDB. It is also worth noting
that the database `password` is stored as a parameter in plain text. Users should likely be storing this value as eyaml in hiera.
This will be fixed in the future as the MongoDB module accepts a hex encoded md5 hash of "user1:mongo:pass1".



## Development

Pull requests welcome. Please create a new feature branch for any additions.

## Additional Information

Any additional information and configuration regarding Let's Chat can be found on their [Wiki Page](https://github.com/sdelements/lets-chat/wiki)
