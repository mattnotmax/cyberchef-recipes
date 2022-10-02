#
# Cookbook Name:: mysql
# Attributes:: client
#
# Copyright 2008-2009, Opscode, Inc.
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
#
# Include Opscode helper in Node class to get access
# to debian_before_squeeze? and ubuntu_before_lucid?
::Chef::Node.send(:include, Opscode::Mysql::Helpers)

case node['platform_family']
when "rhel", "fedora"
  default['mysql']['client']['packages'] = %w{mysql mysql-devel}
when "suse"
  default['mysql']['client']['packages'] = %w{mysql-community-server-client libmysqlclient-devel}
when "debian"
  if debian_before_squeeze? || ubuntu_before_lucid?
    default['mysql']['client']['packages'] = %w{mysql-client libmysqlclient15-dev}
  else
    default['mysql']['client']['packages'] = %w{mysql-client libmysqlclient-dev}
  end
when "freebsd"
  default['mysql']['client']['packages'] = %w{mysql55-client}
when "windows"
  default['mysql']['client']['version']      = "6.0.2"
  default['mysql']['client']['arch']         = "win32" # force 32 bit to work with mysql gem
  default['mysql']['client']['package_file'] = "mysql-connector-c-#{mysql['client']['version']}-#{mysql['client']['arch']}.msi"
  default['mysql']['client']['url']          = "http://www.mysql.com/get/Downloads/Connector-C/#{mysql['client']['package_file']}/from/http://mysql.mirrors.pair.com/"
  default['mysql']['client']['packages']     = ["MySQL Connector C #{mysql['client']['version']}"]

  default['mysql']['client']['basedir']      = "#{ENV['SYSTEMDRIVE']}\\Program Files (x86)\\MySQL\\#{mysql['client']['packages'].first}"
  default['mysql']['client']['lib_dir']      = "#{mysql['client']['basedir']}\\lib/opt"
  default['mysql']['client']['bin_dir']      = "#{mysql['client']['basedir']}\\bin"
  default['mysql']['client']['ruby_dir']     = RbConfig::CONFIG['bindir']
when "mac_os_x"
  default['mysql']['client']['packages'] = %w{mysql-connector-c}
else
  default['mysql']['client']['packages'] = %w{mysql-client libmysqlclient-dev}
end

