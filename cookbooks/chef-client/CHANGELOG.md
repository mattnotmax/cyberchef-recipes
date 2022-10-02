chef-client Cookbook CHANGELOG
==============================
This file is used to list changes made in each version of the chef-client cookbook.


v3.1.0
------
### Bug
- **[COOK-3638](https://tickets.opscode.com/browse/COOK-3638)** - Use standard posix shell `/bin/sh` instead of `/bin/bash`
- **[COOK-3637](https://tickets.opscode.com/browse/COOK-3637)** - Fix typo in README
- **[COOK-3501](https://tickets.opscode.com/browse/COOK-3501)** - Notify reload `:immediately` when `client.rb` template is changed
- **[COOK-3492](https://tickets.opscode.com/browse/COOK-3492)** - Test upstart on CentOS

### New Feature
- **[COOK-3500](https://tickets.opscode.com/browse/COOK-3500)** - Rotate logs on supported platforms if 'log_file' is set

### Improvement
- **[COOK-1863](https://tickets.opscode.com/browse/COOK-1863)** - Install chef-client as a Windows Service

v3.0.6
------
### Bug
- **[COOK-3373](https://tickets.opscode.com/browse/COOK-3373)** - Provide full syslog custom config example in README
- **[COOK-3301](https://tickets.opscode.com/browse/COOK-3301)** - Fix MiniTest Cron Recipe
- **[COOK-3300](https://tickets.opscode.com/browse/COOK-3300)** - Allow environment variables (not require)
- **[COOK-3276](https://tickets.opscode.com/browse/COOK-3276)** - Use `node.default` instead of `node.set`
- **[COOK-3227](https://tickets.opscode.com/browse/COOK-3227)** - Fix misnamed attribute
- **[COOK-3104](https://tickets.opscode.com/browse/COOK-3104)** - Update `.kitchen.yml` to properly set environment_variables

v3.0.4
------
### Bug
- [COOK-3159]: don't skip directory creation on Windows

v3.0.2
------
### Bug
- [COOK-3157]: correct root group detection for Windows

v3.0.0
------
### Sub-task
- [COOK-1002]: chef-client service is not started for `init_style` = init
- [COOK-1191]: chef-client cookbook doesn't log to /var/log/chef/client.log when using `init_style` runit
- [COOK-2319]: The service recipe has too many lines of code
- [COOK-2344]: chef-client config should preserve log settings
- [COOK-2651]: The cron task fails to disable and stop service if the init_style is set to upstart
- [COOK-2709]: chef-client needs explicit dependancy on cron >= 1.2.0
- [COOK-2856]: Use attribute/data driven configuration for /etc/chef/client.rb
- [COOK-2857]: Update chef-client to use runit v1.0+
- [COOK-2858]: support "inclusion" of other Chef Config files in client.rb
- [COOK-3110]: kitchen.yml missing chef-client::config in cook-2317 runlist
- [COOK-3112]: `chef_client` test cook-1951 fails as provided

### Bug
- [COOK-2607]: detect if node is a chef-server and set user/group file ownership correctly
- [COOK-3104]: kitchen.yml file for chef-client doesn't properly set `environment_variables`

### Improvement
- [COOK-2637]: Silence expected errors from which based chef-server checks
- [COOK-2825]: SMF for chef-client should use :kill to stop service

v2.2.4
------
### Bug
- [COOK-2687]: chef-client::service doesn't work on SLES 11
- [COOK-2689]: chef-client service recipe on windows fails to start
- [COOK-2700]: chef-client cookbook should have more splay
- [COOK-2952]: chef-client cookbook has foodcritic failures

### Sub-task
- [COOK-2823]: Chef-client SMF manifest should set locale to UTF-8

v2.2.2
------
- [COOK-2393] - chef-client::delete_validation checks for chef-server in the path, on chef 11, needs to check for chef-server-ctl
- [COOK-2410] - chef-client::service doesn't always start the chef-client daemon
- [COOK-2413] - Deprecation warning when using Chef::Mixin::Language in chef-client cookbook under chef 11.x
- [COOK-2446] - Typo: the chef-client executable has a hyphen
- [COOK-2492] - Ruby System("") call that includes an '&' on Ubuntu has odd behavior.
- [COOK-2536] - On Freebsd - chef-client group values in helper library should be set to "wheel" vs [ "wheel" ]

v2.2.0
------
- [COOK-2317] - Provide the ability to add disabled ohai plugins in a managed chef config
- [COOK-2255] - Chef-Client Cookbook init.d script under ubuntu

v2.1.10
------
- [COOK-2316] - Permissions for SMF init type break Solaris 10

v2.1.8
------
- [COOK-2192] - Add option to use cron_d resource for cron management
- [COOK-2261] - pin runit dependency

v2.1.6
------
- [COOK-1978] - make cron output location configurable
- [COOK-2169] - use helper library to make path permissions consistent
- [COOK-2170] - test filename cleanup (dev repository only)

v2.1.4
------
- [COOK-2108] - corrected Chef and Ohai version requirements in README

v2.1.2
------
- [COOK-2071] - chef-client breaks on value_for_platform_family b/c of unneeded version
- [COOK-2072] - chef-client on mac should not attempt to create directory nil
- [COOK-2086] - Allow the passing of an enviornment variables to node['chef-client']['bin']
- [COOK-2092] - chef-client run fails because quotes in log_path cause File resource to fail

v2.1.0
------
- [COOK-1755] - Don't delete the validation key on systems that have a 'chef-server' binary in the default $PATH
- [COOK-1898] - Support Handlers and Cache Options with Attributes
- [COOK-1923] - support chef-client::cron on Solaris/SmartOS
- [COOK-1924] - use splay for size of random offset in chef-client::cron
- [COOK-1927] - unknown node[:fqdn] prevents bootstrap if chef-client::cron is in runlist
- [COOK-1951] - Add an attribute for additional daemon options to pass to the chef-client service
- [COOK-2004] - in attributes, "init" style claims to handle fedora, but service.rb missing a clause
- [COOK-2017] - Support alternate chef-client locations in Mac OS X Launchd service plist
- [COOK-2052] - Log files are set to insecure default

v2.0.2
------
- Remove a stray comma that caused syntax error on some versions of Ruby.

v2.0.0
------
This version uses platform_family attribute, making the cookbook incompatible with older versions of Chef/Ohai, hence the major version bump.

- [COOK-635] - Allow configuration of path to chef-client binary in init script
- [COOK-985] - set correct permissions on run and log directory for chef-servers using this cookbook
- [COOK-1379] - Register chef-client as a launchd service on Mac OS X (Server)
- [COOK-1574] - config recipe doesn't work on Windows
- [COOK-1586] - add SmartOS support
- [COOK-1633] - chef-client doesn't recognise Oracle Linux, a Redhat family member
- [COOK-1634] - chef-client init is missing for Scientific Linux
- [COOK-1664] - corrected permissions in cron recipe (related to COOK-985)
- [COOK-1729] - support windows task
- [COOK-1788] - `init_style` upstart only works on Ubuntu
- [COOK-1861] - Minor styling fix for consistency in chef-client
- [COOK-1862] - add `name` attribute to metadata.rb

v1.2.0
------
This version of the cookbook also adds minitest and test-kitchen support.

- [COOK-599] - chef-client::config recipe breaks folder permissions of chef-server::rubygems-install recipe on same node
- [COOK-1111] - doesn't work out of the box with knife bootstrap windows
- [COOK-1161] - allow setting log file and environment in client.rb
- [COOK-1203] - allow PATH setting for cron
- [COOK-1254] - service silently fails on ubuntu 12.04 with ruby 1.9.3
- [COOK-1309] - cron recipe expects SANE_PATHS constant
- [COOK-1345] - preformat log location before sending to template
- [COOK-1377] - allow client.rb to require gems
- [COOK-1419] - add init script for SUSE
- [COOK-1463] - Add verbose_logging knob for config recipe, client.rb template
- [COOK-1506] - set an attribute for server_url
- [COOK-1566] - remove random splay for unique sleep number

v1.1.4
------
- [COOK-599] - don't break folder permissions if chef-server recipe is present

v1.1.2
------
- [COOK-1039] - support mac_os_x_server

v1.1.0
------
- [COOK-909] - trigger upstart on correct event
- [COOK-795] - add windows support with winsw
- [COOK-798] - added recipe to run chef-client as a cron job
- [COOK-986] - don't delete the validation.pem if chef-server recipe is detected

v1.0.4
------
- [COOK-670] - Added Solaris service-installation support for chef-client cookbook.
- [COOK-781] - chef-client service recipe fails with chef 0.9.x

v1.0.2
------
- [CHEF-2491] init scripts should implement reload

v1.0.0
------
- [COOK-204] chef::client pid template doesn't match package expectations
- [COOK-491] service config/defaults should not be pulled from Chef gem
- [COOK-525] Tell bluepill to daemonize chef-client command
- [COOK-554] Typo in backup_path
- [COOK-609] chef-client cookbook fails if init_type is set to upstart and chef is installed from deb
- [COOK-635] Allow configuration of path to chef-client binary in init script
