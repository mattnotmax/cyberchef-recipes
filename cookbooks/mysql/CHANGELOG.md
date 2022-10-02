mysql Cookbook CHANGELOG
========================
This file is used to list changes made in each version of the mysql cookbook.

v3.0.4
------
### Bug
- **[COOK-3310](https://tickets.opscode.com/browse/COOK-3310)** - Fix missing `GRANT` option
- **[COOK-3233](https://tickets.opscode.com/browse/COOK-3233)** - Fix escaping special characters
- **[COOK-3156](https://tickets.opscode.com/browse/COOK-3156)** - Fix GRANTS file when `remote_root_acl` is specified
- **[COOK-3134](https://tickets.opscode.com/browse/COOK-3134)** - Fix Chef 11 support
- **[COOK-2318](https://tickets.opscode.com/browse/COOK-2318)** - Remove redundant `if` block around `node.mysql.tunable.log_bin`

v3.0.2
------
### Bug
- [COOK-2158]: apt-get update is run twice at compile time
- [COOK-2832]: mysql grants.sql file has errors depending on attrs
- [COOK-2995]: server.rb is missing a platform_family comparison value

### Sub-task
- [COOK-2102]: `innodb_flush_log_at_trx_commit` value is incorrectly set based on CPU count

v3.0.0
------
**Note** This is a backwards incompatible version with previous versions of the cookbook. Tickets that introduce incompatibility are COOK-2615 and COOK-2617.

- [COOK-2478] - Duplicate 'read_only' server attribute in base and tunable
- [COOK-2471] - Add tunable to set slave_compressed_protocol for reduced network traffic
- [COOK-1059] - Update attributes in mysql cookbook to support missing options for my.cnf usable by Percona
- [COOK-2590] - Typo in server recipe to do with conf_dir and confd_dir
- [COOK-2602] - Add `lower_case_table_names` tunable
- [COOK-2430] - Add a tunable to create a network ACL when allowing `remote_root_access`
- [COOK-2619] - mysql: isamchk deprecated
- [COOK-2515] - Better support for SUSE distribution for mysql cookbook
- [COOK-2557] - mysql::percona_repo attributes missing and key server typo
- [COOK-2614] - Duplicate `innodb_file_per_table`
- [COOK-2145] - MySQL cookbook should remove anonymous and password less accounts
- [COOK-2553] - Enable include directory in my.cnf template for any platform
- [COOK-2615] - Rename `key_buffer` to `key_buffer_size`
- [COOK-2626] - Percona repo URL is being constructed incorrectly
- [COOK-2616] - Unneeded attribute thread_cache
- [COOK-2618] - myisam-recover not using attribute value
- [COOK-2617] - open-files is a duplicate of open-files-limit

v2.1.2
------
- [COOK-2172] - Mysql cookbook duplicates `binlog_format` configuration

v2.1.0
------
- [COOK-1669] - Using platform("ubuntu") in default attributes always returns true
- [COOK-1694] - Added additional my.cnf fields and reorganized cookbook to avoid race conditions with mysql startup and sql script execution
- [COOK-1851] - Support server-id and binlog_format settings
- [COOK-1929] - Update msyql server attributes file because setting attributes without specifying a precedence is deprecated
- [COOK-1999] - Add read_only tunable useful for replication slave servers

v2.0.2
------
- [COOK-1967] - mysql: trailing comma in server.rb platform family

v2.0.0
------
**Important note for this release**

Under Chef Solo, you must set the node attributes for the root, debian and repl passwords or the run will completely fail. See COOK-1737 for background on this.

- [COOK-1390] - MySQL service cannot start after reboot
- [COOK-1610] - Set root password outside preseed (blocker for drop-in mysql replacements)
- [COOK-1624] - Mysql cookbook fails to even compile on windows
- [COOK-1669] - Using platform("ubuntu") in default attributes always returns true
- [COOK-1686] - Add mysql service start
- [COOK-1687] - duplicate `innodb_buffer_pool_size` attribute
- [COOK-1704] - mysql cookbook fails spec tests when minitest-handler cookbook enabled
- [COOK-1737] - Fail a chef-solo run when `server_root_password`, `server_debian_password`, and/or `server_repl_password` is not set
- [COOK-1769] - link to database recipe in mysql README goes to old opscode/cookbooks repo instead of opscode-cookbook organization
- [COOK-1963] - use `platform_family`

v1.3.0
------
**Important note for this release**

This version no longer installs Ruby bindings in the client recipe by default. Use the ruby recipe if you'd like the RubyGem. If you'd like packages from your distribution, use them in your application's specific cookbook/recipe, or modify the client packages attribute. This resolves the following tickets:

- COOK-932
- COOK-1009
- COOK-1384

Additionally, this cookbook now has tests (COOK-1439) for use under test-kitchen.

The following issues are also addressed in this release.

- [COOK-1443] - MySQL (>= 5.1.24) does not support `innodb_flush_method` = fdatasync
- [COOK-1175] - Add Mac OS X support
- [COOK-1289] - handle additional tunable attributes
- [COOK-1305] - add auto-increment-increment and auto-increment-offset attributes
- [COOK-1397] - make the port an attribute
- [COOK-1439] - Add MySQL cookbook tests for test-kitchen support
- [COOK-1236] - Move package names into attributes to allow percona to free-ride
- [COOK-934] - remove deprecated mysql/libraries/database.rb, use the database cookbook instead.
- [COOK-1475] - fix restart on config change

v1.2.6
------
- [COOK-1113] - Use an attribute to determine if upstart is used
- [COOK-1121] - Add support for Windows
- [COOK-1140] - Fix conf.d on Debian
- [COOK-1151] - Fix server_ec2 handling /var/lib/mysql bind mount
- [COOK-1321] - Document setting password attributes for solo

v1.2.4
------
- [COOK-992] - fix FATAL nameerror
- [COOK-827] - `mysql:server_ec2` recipe can't mount `data_dir`
- [COOK-945] - FreeBSD support

v1.2.2
------
- [COOK-826] mysql::server recipe doesn't quote password string
- [COOK-834] Add 'scientific' and 'amazon' platforms to mysql cookbook

v1.2.1
------
- [COOK-644] Mysql client cookbook 'package missing' error message is confusing
- [COOK-645] RHEL6/CentOS6 - mysql cookbook contains 'skip-federated' directive which is unsupported on MySQL 5.1

v1.2.0
------
- [COOK-684] remove mysql_database LWRP

v1.0.8
------
- [COOK-633] ensure "cloud" attribute is available

v1.0.7
------
- [COOK-614] expose all mysql tunable settings in config
- [COOK-617] bind to private IP if available

v1.0.6
------
- [COOK-605] install mysql-client package on ubuntu/debian

v1.0.5
------
- [COOK-465] allow optional remote root connections to mysql
- [COOK-455] improve platform version handling
- externalize conf_dir attribute for easier cross platform support
- change datadir attribute to data_dir for consistency

v1.0.4
------
- fix regressions on debian platform
- [COOK-578] wrap root password in quotes
- [COOK-562] expose all tunables in my.cnf
