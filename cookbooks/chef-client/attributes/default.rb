#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: chef
# Attributes:: default
#
# Copyright 2008-2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rbconfig'

# We only set these by default because this is what comes from `knife
# bootstrap` (the best way to install Chef Client on managed nodes).
#
# Users can add other configuration options through attributes in
# their favorite way (role, "site" cookbooks, etc).
default['chef_client']['config'] = {
  'chef_server_url' => Chef::Config[:chef_server_url],
  'validation_client_name' => Chef::Config[:validation_client_name],
  'node_name' => Chef::Config[:node_name] == node['fqdn'] ? false : Chef::Config[:node_name]
}

# By default, we don't have a log file, as we log to STDOUT
default["chef_client"]["log_file"]    = nil
default["chef_client"]["interval"]    = "1800"
default["chef_client"]["splay"]       = "300"
default["chef_client"]["conf_dir"]    = "/etc/chef"
default["chef_client"]["bin"]         = "/usr/bin/chef-client"

# Set a sane default log directory location, overriden by specific
# platforms below.
default["chef_client"]["log_dir"]     = "/var/log/chef"

# Configuration for chef-client::cron recipe.
default["chef_client"]["cron"] = {
  "minute" => "0",
  "hour" => "*/4",
  "path" => nil,
  "environment_variables" => nil,
  "log_file" => "/dev/null",
  "use_cron_d" => false
}

default["chef_client"]["load_gems"] = {}

# Any additional daemon options can be set as an array. This will be
# join'ed in the relevant service configuration.
default["chef_client"]["daemon_options"] = []

# Ohai plugins to be disabled are configured in /etc/chef/client.rb,
# so they can be set as an array in this attribute.
default["ohai"]["disabled_plugins"] = []

# Use logrotate_app definition on supported platforms via config recipe
# when chef_client["log_file"] is set.
# Default rotate: 12; frequency: weekly
default["chef_client"]["logrotate"]["rotate"] = 12
default["chef_client"]["logrotate"]["frequency"] = "weekly"

case node['platform_family']
when "arch"
  default["chef_client"]["init_style"]  = "arch"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/cache/chef"
  default["chef_client"]["backup_path"] = "/var/lib/chef"
when "debian","rhel","fedora","suse"
  default["chef_client"]["init_style"]  = "init"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/cache/chef"
  default["chef_client"]["backup_path"] = "/var/lib/chef"
when "openbsd","freebsd"
  default["chef_client"]["init_style"]  = "bsd"
  default["chef_client"]["run_path"]    = "/var/run"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
# don't use bsd paths per COOK-1379
when "mac_os_x","mac_os_x_server"
  default["chef_client"]["init_style"]  = "launchd"
  default["chef_client"]["log_dir"]     = "/Library/Logs/Chef"
  # Launchd doesn't use pid files
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/Library/Caches/Chef"
  default["chef_client"]["backup_path"] = "/Library/Caches/Chef/Backup"
  # Set to "daemon" if you want chef-client to run
  # continuously with the -d and -s options, or leave
  # as "interval" if you want chef-client to be run
  # periodically by launchd
  default["chef_client"]["launchd_mode"] = "interval"
when "openindiana","opensolaris","nexentacore","solaris2"
  default["chef_client"]["init_style"]  = "smf"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
  default["chef_client"]["method_dir"] = "/lib/svc/method"
  default["chef_client"]["bin_dir"] = "/usr/bin"
when "smartos"
  default["chef_client"]["init_style"]  = "smf"
  default["chef_client"]["run_path"]    = "/var/run/chef"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
  default["chef_client"]["method_dir"] = "/opt/local/lib/svc/method"
  default["chef_client"]["bin_dir"] = "/opt/local/bin"
when "windows"
  default["chef_client"]["init_style"]  = "windows"
  default["chef_client"]["conf_dir"]    = "C:/chef"
  default["chef_client"]["run_path"]    = "#{node["chef_client"]["conf_dir"]}/run"
  default["chef_client"]["cache_path"]  = "#{node["chef_client"]["conf_dir"]}/cache"
  default["chef_client"]["backup_path"] = "#{node["chef_client"]["conf_dir"]}/backup"
  default["chef_client"]["log_dir"]     = "#{node["chef_client"]["conf_dir"]}/log"
  default["chef_client"]["bin"]         = "C:/opscode/chef/bin/chef-client"
  #Required for minsw wrapper
  default["chef_client"]["ruby_bin"]    = File.join(RbConfig::CONFIG['bindir'], "ruby.exe")
  default["chef_client"]["winsw_url"]   = "http://repo1.maven.org/maven2/com/sun/winsw/winsw/1.9/winsw-1.9-bin.exe"
  default["chef_client"]["winsw_dir"]   = "C:/chef/bin"
  default["chef_client"]["winsw_exe"]   = "chef-client.exe"
else
  default["chef_client"]["init_style"]  = "none"
  default["chef_client"]["run_path"]    = "/var/run"
  default["chef_client"]["cache_path"]  = "/var/chef/cache"
  default["chef_client"]["backup_path"] = "/var/chef/backup"
end
