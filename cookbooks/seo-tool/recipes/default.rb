#
# Cookbook Name:: seo-tool
# Recipe:: default

node['mysql']['server_debian_password'] = ''
node['mysql']['server_root_password'] = ''
node['mysql']['server_repl_password'] = ''

node['rvm']['rubies'] = ['2.0.0']
node['rvm']['default_ruby'] = 'ruby-2.0.0-p247'
node['rvm']['user_default_ruby'] = 'vagrant'
node['rvm']['vagrant']['system_chef_solo'] = '/usr/bin/chef-solo'

include_recipe "git"
include_recipe "build-essential"
include_recipe "nodejs"
include_recipe "openssl"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "rvm::vagrant"
include_recipe "rvm::system"

service "iptables" do
  action :disable
end