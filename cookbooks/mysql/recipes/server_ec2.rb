#
# Cookbook Name:: mysql
# Recipe:: default
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


if (node.attribute?('ec2') && ! FileTest.directory?(node['mysql']['ec2_path']))

  service "mysql" do
    action :stop
  end

  execute "install-mysql" do
    command "mv #{node['mysql']['data_dir']} #{node['mysql']['ec2_path']}"
    not_if do FileTest.directory?(node['mysql']['ec2_path']) end
  end

  [node['mysql']['ec2_path'], node['mysql']['data_dir']].each do |dir|
    directory dir do
      owner "mysql"
      group "mysql"
    end
  end

  mount node['mysql']['data_dir'] do
    device node['mysql']['ec2_path']
    fstype "none"
    options "bind,rw"
    action [:mount, :enable]
  end

  service "mysql" do
    action :start
  end

end

