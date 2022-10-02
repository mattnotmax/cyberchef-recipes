#
# Cookbook Name:: rvm
# Provider:: gemset
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
include Chef::RVM::RubyHelpers
include Chef::RVM::GemsetHelpers

def load_current_resource
  if new_resource.ruby_string
    @rubie      = normalize_ruby_string(select_ruby(new_resource.ruby_string))
    @gemset     = new_resource.gemset
  else
    @rubie      = normalize_ruby_string(select_ruby(new_resource.gemset))
    @gemset     = select_gemset(new_resource.gemset)
  end
  @ruby_string  = "#{@rubie}@#{@gemset}"
  @rvm_env      = ::RVM::ChefUserEnvironment.new(new_resource.user)
end

action :create do
  unless ruby_installed?(@rubie)
    r = rvm_ruby @rubie do
      user    new_resource.user
      action :nothing
    end
    r.run_action(:install)
  end

  if gemset_exists?(:ruby => @rubie, :gemset => @gemset)
    Chef::Log.debug("rvm_gemset[#{@ruby_string}] already exists, so skipping")
  else
    Chef::Log.info("Creating rvm_gemset[#{@ruby_string}]")

    @rvm_env.use @rubie
    if @rvm_env.gemset_create @gemset
      update_installed_gemsets(@rubie)
      Chef::Log.debug("Creation of rvm_gemset[#{@ruby_string}] was successful.")
    else
      Chef::Log.warn("Failed to create rvm_gemset[#{@ruby_string}].")
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if gemset_exists?(:ruby => @rubie, :gemset => @gemset)
    Chef::Log.info("Deleting rvm_gemset[#{@ruby_string}]")

    @rvm_env.use @rubie
    if @rvm_env.gemset_delete @gemset
      update_installed_gemsets(@rubie)
      Chef::Log.debug("Deletion of rvm_gemset[#{@ruby_string}] was successful.")
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.warn("Failed to delete rvm_gemset[#{@ruby_string}].")
    end
  else
    Chef::Log.debug("rvm_gemset[#{@ruby_string}] does not exist, so skipping")
  end
end

action :empty do
  if gemset_exists?(:ruby => @rubie, :gemset => @gemset)
    Chef::Log.info("Emptying rvm_gemset[#{@ruby_string}]")

    @rvm_env.use @ruby_string
    if @rvm_env.gemset_empty
      update_installed_gemsets(@rubie)
      Chef::Log.debug("Emptying of rvm_gemset[#{@ruby_string}] was successful.")
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.warn("Failed to empty rvm_gemset[#{@ruby_string}].")
    end
  else
    Chef::Log.debug("rvm_gemset[#{@ruby_string}] does not exist, so skipping")
  end
end

action :update do
  Chef::Log.info("Updating rvm_gemset[#{@ruby_string}]")

  # create gemset if it doesn't exist
  unless gemset_exists?(:ruby => @rubie, :gemset => @gemset)
    c = rvm_gemset @ruby_string do
      user    new_resource.user
      action :nothing
    end
    c.run_action(:create)
  end

  @rvm_env.use @ruby_string
  if @rvm_env.gemset_update
    update_installed_gemsets(@rubie)
    Chef::Log.debug("Updating of rvm_gemset[#{@ruby_string}] was successful.")
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.warn("Failed to update rvm_gemset[#{@ruby_string}].")
  end
end
