#
# Cookbook Name:: rvm
# Provider:: environment
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
  @rubie        = normalize_ruby_string(select_ruby(new_resource.ruby_string))
  @gemset       = select_gemset(new_resource.ruby_string)
  @ruby_string  = @gemset.nil? ? @rubie : "#{@rubie}@#{@gemset}"
  @rvm_env      = ::RVM::ChefUserEnvironment.new(new_resource.user)
end

action :create do
  next if skip_environment?

  if @gemset
    gemset_resource :create
  else
    ruby_resource   :install
  end
end

private

def skip_environment?
  if @rubie.nil?
    Chef::Log.warn("#{self.class.name}: RVM ruby string `#{@rubie}' " +
      "is not known. Use `rvm list known` to get a full list.")
    true
  else
    false
  end
end

def gemset_resource(exec_action)
  # ensure gemset is created, if specified
  unless gemset_exists?(:ruby => @rubie, :gemset => @gemset)
    r = rvm_gemset @ruby_string do
      user    new_resource.user
      action  :nothing
    end
    r.run_action(exec_action)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end

def ruby_resource(exec_action)
  # ensure ruby is installed
  unless ruby_installed?(@rubie)
    r = rvm_ruby @rubie do
      user    new_resource.user
      action :nothing
    end
    r.run_action(exec_action)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end
