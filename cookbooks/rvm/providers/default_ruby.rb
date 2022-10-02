#
# Cookbook Name:: rvm
# Provider:: default_ruby
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
end

action :create do
  next if skip_ruby?

  # ensure ruby is installed and gemset exists (if specified)
  unless env_exists?(@ruby_string)
    e = rvm_environment @ruby_string do
      user    new_resource.user
      action  :nothing
    end
    e.run_action(:create)
  end

  Chef::Log.info("Setting default ruby to rvm_ruby[#{@ruby_string}]")
  @rvm_env.rvm :use, @ruby_string, :default => true
  new_resource.updated_by_last_action(true)
end

private

def skip_ruby?
  if @rubie.nil?
    Chef::Log.warn("#{self.class.name}: RVM ruby string `#{@rubie}' " +
      "is not known. Use `rvm list known` to get a full list.")
    true
  elsif ruby_default?(@ruby_string)
    Chef::Log.debug("#{self.class.name}: `#{@ruby_string}' is already default, " +
      "so skipping")
    true
  else
    false
  end
end
