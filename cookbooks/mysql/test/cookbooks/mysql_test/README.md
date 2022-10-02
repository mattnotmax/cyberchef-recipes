Description
===========

This cookbook defines acceptance tests for MySQL. It includes:

* A `features` sub-directory where the Cucumber features for the database
  are defined.

* Creation of a simple test database for the tests to run against.

Usage
=====

Set environment variable `TEST_SERVER_HOST` to specify the MySQL server to
connect to. You can optionally set `TEST_CLIENT_HOST` which will test a client
install by running the same features from a remote client.

Requirements
============

## Cookbooks:

This cookbook depends on the `mysql` cookbook. It also uses the `database`
cookbook to create the test database and relies on the `yum` cookbook in order
to add the EPEL repository on RHEL-derived distributions.

## Platforms:

* Ubuntu
* CentOS

Attributes
==========

* `node['mysql_test']['database']` - The name of the test database to create.
* `node['mysql_test']['username']` - The username of the datbase user.
* `node['mysql_test']['password']` - The password of the database user.

Recipes
=======

* `client` - Simply includes `mysql::client` for a vanilla mysql client install.
* `server` - Includes `mysql::server` to install the server and configures a
  test database.

License and Authors
===================

Author:: Andrew Crump <andrew@kotirisoftware.com>

    Copyright:: 2012, Opscode, Inc

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
