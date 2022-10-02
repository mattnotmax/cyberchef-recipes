#
# Cookbook Name:: rvm
# Provider:: wrapper
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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

include Chef::RVM::StringHelpers
include Chef::RVM::EnvironmentHelpers

def load_current_resource
  @rubie        = normalize_ruby_string(select_ruby(new_resource.ruby_string))
  @gemset       = select_gemset(new_resource.ruby_string)
  @ruby_string  = @gemset.nil? ? @rubie : "#{@rubie}@#{@gemset}"
  @rvm_env      = ::RVM::ChefUserEnvironment.new(new_resource.user)

  if new_resource.binary.nil?
    @binaries = new_resource.binaries || []
  else
    @binaries = [ new_resource.binary ] || []
  end
end

action :create do
  # ensure ruby is installed and gemset exists
  unless env_exists?(@ruby_string)
    e = rvm_environment @ruby_string do
      user    new_resource.user
      action :nothing
    end
    e.run_action(:create)
  end

  @rvm_env.use @ruby_string

  @binaries.each { |b| create_wrapper(b) }
end

private

def create_wrapper(bin)
  full_bin = "#{new_resource.prefix}_#{bin}"
  resource_name = "rvm_wrapper[#{full_bin}::#{@ruby_string}]"
  script = ::File.join(@rvm_env.config["rvm_path"], "bin", full_bin)

  if ::File.exists?(script)
    Chef::Log.debug("#{resource_name} already exists, so updating")
  else
    Chef::Log.info("Creating #{resource_name}")
  end

  if @rvm_env.wrapper @ruby_string, new_resource.prefix, bin
    Chef::Log.debug("Creation/Update of #{resource_name} was successful.")
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.warn("Failed to create/update #{resource_name}.")
  end
end
