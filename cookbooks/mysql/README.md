mysql Cookbook
==============
Installs and configures MySQL client or server.


Requirements
------------
Chef 0.10.10+.


Platform
--------
- Debian, Ubuntu
- CentOS, Red Hat, Fedora
- Mac OS X (Using homebrew)

Tested on:

- Debian 5.0, 6.0
- Ubuntu 10.04-12.04
- CentOS 5.5-5.8, 6.2-6.3
- Mac OS X 10.7.2

See TESTING.md for information about running tests in Opscode's Test Kitchen.


Cookbooks
---------
Requires Opscode's openssl cookbook for secure password generation. See _Attributes_ and _Usage_ for more information.

The RubyGem installation in the `mysql::ruby` recipe requires a C compiler and Ruby development headers to be installed in order to build the mysql gem.

Requires `homebrew` [cookbook](http://community.opscode.com/cookbooks/homebrew) on Mac OS X.


Resources and Providers
-----------------------
The LWRP that used to ship as part of this cookbook has been refactored into the
[database](http://community.opscode.com/cookbooks/database) cookbook. Please see the README for details on updated usage.


Attributes
----------
See the `attributes/server.rb` or `attributes/client.rb` for default values. Several attributes have values that vary based on the node's platform and version.

* `node['mysql']['client']['packages']` - An array of package names
  that should be installed on "client" systems. This can be modified,
  e.g., to specify packages for Percona.
* `node['mysql']['server']['packages']` - An array of package names
  that should be installed on "server" systems. This can be modified,
  e.g., to specify packages for Percona.

* `node['mysql']['auto-increment-increment']` -
  auto-increment-increment value in my.cnf
* `node['mysql']['auto-increment-offset]` - auto-increment-offset
  value in my.cnf
* `node['mysql']['basedir']` - Base directory where MySQL is installed
* `node['mysql']['bind_address']` - Listen address for MySQLd
* `node['mysql']['conf_dir']` - Location for mysql conf directory
* `node['mysql']['confd_dir']` - Location for mysql conf.d style
  include directory
* `node['mysql']['data_dir']` - Location for mysql data directory
* `node['mysql']['ec2_path']` - location of mysql data_dir on EC2
  nodes
* `node['mysql']['grants_path']` - Path where the grants.sql should be
  written
* `node['mysql']['mysqladmin_bin']` - Path to the mysqladmin binary
* `node['mysql']['old_passwords']` - Sets the `old_passwords` value in
  my.cnf.
* `node['mysql']['pid_file']` - Path to the mysqld.pid file
* `node['mysql']['port']` - Listen port for MySQLd
* `node['mysql']['reload_action']` - Action to take when mysql conf
  files are modified. Also allows "reload" and "none".
* `node['mysql']['root_group']` - The default group of the "root" user
* `node['mysql']['service_name']` - The name of the mysqld service
* `node['mysql']['socket']` - Path to the mysqld.sock file
* `node['mysql']['use_upstart']` - Whether to use upstart for the
  service provider
* `mysql['root_network_acl']` - Set define the network the root user will be able to login from, default is nil

Performance and other "tunable" attributes are under the `node['mysql']['tunable']` attribute, corresponding to the same-named parameter in my.cnf, and the default values are used. See `attributes/server.rb`.

By default, a MySQL installation has an anonymous user, allowing anyone to log into MySQL without having to have a user account created for them.  This is intended only for testing, and to make the installation go a bit smoother.  You should remove them before moving into a production environment.

* `node['mysql']['remove_anonymous_users']` - Remove anonymous users

Normally, root should only be allowed to connect from 'localhost'.  This ensures that someone cannot guess at the root password from the network.

* `node['mysql']['allow_remote_root']` - If true Sets root access from '%'. If false deletes any non-localhost root users.

By default, MySQL comes with a database named 'test' that anyone can access.  This is also intended only for testing, and should be removed before moving into a production environment. This will also drop any user privileges to the test database and any DB named test_% .

* `node['mysql']['remove_test_database']` - Delete the test database and access to it.

The following attributes are randomly generated passwords handled in the `mysql::server` recipe, using the OpenSSL cookbook's `secure_password` helper method. These are set using the `set_unless` node attribute method, which allows them to be easily overridden e.g.
in a role.

* `node['mysql']['server_root_password']` - Set the server's root
  password
* `node['mysql']['server_repl_password']` - Set the replication user
  'repl' password
* `node['mysql']['server_debian_password']` - Set the debian-sys-maint
  user password

### Windows Specific

The following attributes are specific to Windows platforms.

* `node['mysql']['client']['version']` - The version of MySQL
  connector to install.
* `node['mysql']['client']['arch']` - Force 32 bit to work with the
  mysql gem
* `node['mysql']['client']['package_file']` - The MSI file for the
  mysql connector.
* `node['mysql']['client']['url']` - URL to download the mysql
  connector.
* `node['mysql']['client']['packages']` - Similar to other platforms,
  this is the name of the client package.
* `node['mysql']['client']['basedir']` - Base installation location
* `node['mysql']['client']['lib_dir']` - Libraries under the base location
* `node['mysql']['client']['bin_dir']` - binary directory under base location
* `node['mysql']['client']['ruby_dir']` - location where the Ruby
  binaries will be


Usage
-----
On client nodes, use the client (or default) recipe:

```javascript
{ "run_list": ["recipe[mysql::client]"] }
```

This will install the MySQL client libraries and development headers on the system.

On nodes which may use the `database` cookbook's mysql resources, also use the ruby recipe. This installs the mysql RubyGem in the Ruby environment Chef is using via `chef_gem`.

```javascript
{ "run_list": ["recipe[mysql::client]", "recipe[mysql::ruby]"] }
```

If you need to install the mysql Ruby library as a package for your system, override the client packages attribute in your node or role. For example, on an Ubuntu system:

```javascript
{
  "mysql": {
    "client": {
      "packages": ["mysql-client", "libmysqlclient-dev","ruby-mysql"]
    }
  }
}
```

This creates a resource object for the package and does the installation before other recipes are parsed. You'll need to have the C compiler and such (ie, build-essential on Ubuntu) before running the recipes, but we already do that when installing Chef :-).

On server nodes, use the server recipe:

```javascript
{ "run_list": ["recipe[mysql::server]"] }
```

On Debian and Ubuntu, this will preseed the mysql-server package with the randomly generated root password in the recipe file. On other platforms, it simply installs the required packages. It will also create an SQL file, `/etc/mysql/grants.sql`, that will be used to set up grants for the root, repl and debian-sys-maint users.

The recipe will perform a `node.save` unless it is run under `chef-solo` after the password attributes are used to ensure that in the event of a failed run, the saved attributes would be used.

On EC2 nodes, use the `server_ec2` recipe and the mysql data dir will be set up in the ephmeral storage.

```javascript
{ "run_list": ["recipe[mysql::server_ec2]"] }
```

When the `ec2_path` doesn't exist we look for a mounted filesystem (eg, EBS) and move the data_dir there.

The client recipe is already included by server and 'default' recipes.

For more infromation on the compile vs execution phase of a Chef run:

- http://wiki.opscode.com/display/chef/Anatomy+of+a+Chef+Run


Chef Solo Note
--------------
These node attributes are stored on the Chef server when using `chef-client`. Because `chef-solo` does not connect to a server or save the node object at all, to have the same passwords persist across `chef-solo` runs, you must specify them in the `json_attribs` file used. For example:

```javascript
{
  "mysql": {
    "server_root_password": "iloverandompasswordsbutthiswilldo",
    "server_repl_password": "iloverandompasswordsbutthiswilldo",
    "server_debian_password": "iloverandompasswordsbutthiswilldo"
  },
  "run_list":["recipe[mysql::server]"]
}
```


License & Authors
-----------------
- Author:: Joshua Timberman (<joshua@opscode.com>)
- Author:: AJ Christensen (<aj@opscode.com>)
- Author:: Seth Chisamore (<schisamo@opscode.com>)
- Author:: Brian Bianco (<brian.bianco@gmail.com>)
- Author:: Jesse Howarth (<him@jessehowarth.com>)
- Author:: Andrew Crump (<andrew@kotirisoftware.com>)

```text
Copyright:: 2009-2013 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
