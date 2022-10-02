#
# Cookbook Name:: rvm
# Provider:: Chef::Provider::Package::RVMRubygems
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

class Chef
  module RVM
    module ShellHelpers
      # stub to satisfy RVMRubygems (library load order not guarenteed)
    end
    module SetHelpers
      # stub to satisfy RVMRubygems (library load order not guarenteed)
    end
  end

  class Provider
    class Package
      class RVMRubygems < Chef::Provider::Package::Rubygems
        include Chef::RVM::ShellHelpers
        include Chef::RVM::SetHelpers

        class RVMGemEnvironment < AlternateGemEnvironment
          include Chef::RVM::ShellHelpers
          include Chef::RVM::SetHelpers

          attr_reader :ruby_strings, :user

          def initialize(gem_binary_location, ruby_strings, user = nil)
            super(gem_binary_location)
            @ruby_strings = ruby_strings
            @user = user
          end

          def gem_paths
            cmd = "rvm #{ruby_strings.join(',')} "
            cmd << "#{rvm_do(user)} #{@gem_binary_location} env gempath"

            if user
              user_dir    = Etc.getpwnam(user).dir
              environment = { 'USER' => user, 'HOME' => user_dir }
            else
              user_dir    = nil
              environment = nil
            end

            # shellout! is a fork/exec which won't work on windows
            shell_style_paths = shell_out!(
              rvm_wrap_cmd(cmd, user_dir), :env => environment).stdout
            # on windows, the path separator is semicolon
            paths = shell_style_paths.split(
              ::File::PATH_SEPARATOR).map { |path| path.strip }
          end

          def gem_platforms
            cmd = "rvm #{ruby_strings.join(',')} "
            cmd << "#{rvm_do(user)} #{@gem_binary_location} env"

            if user
              user_dir    = Etc.getpwnam(user).dir
              environment = { 'USER' => user, 'HOME' => user_dir }
            else
              user_dir    = nil
              environment = nil
            end

            gem_environment = shell_out!(
              rvm_wrap_cmd(cmd, user_dir), :env => environment).stdout
            if jruby = gem_environment[JRUBY_PLATFORM]
              ['ruby', Gem::Platform.new(jruby)]
            else
              Gem.platforms
            end
          end
        end

        def initialize(new_resource, run_context=nil)
          original_gem_binary = new_resource.gem_binary
          super
          new_resource.gem_binary("gem") unless original_gem_binary
          user = new_resource.respond_to?("user") ? new_resource.user : nil
          @gem_env = RVMGemEnvironment.new(gem_binary_path, ruby_strings, user)
        end

        ##
        # Determine the array of RVM ruby strings to use in this provider.
        # In most cases only a single string value will be specified, but
        # an array is always returned to account for multiple rubies.
        #
        # @return [Array] an array of RVM ruby strings
        def ruby_strings
          @ruby_strings ||= begin
            result = if new_resource.respond_to?("ruby_string")
              # the resource understands `.ruby_string' natively
              new_resource.ruby_string
            else
              # most likely the gem_package resource or another native one
              node['rvm']['gem_package']['rvm_string']
            end

            # if the result is a String, then wrap in an Array, otherwise
            # return the array
            case result
            when String;  [ result ]
            when Array;   result
            end
          end
        end

        def install_package(name, version)
          # ensure each ruby is installed and gemset exists
          ruby_strings.each do |rubie|
            next if rubie == 'system'
            e = rvm_environment rubie do
              user    gem_env.user if gem_env.user
              action :nothing
            end
            e.run_action(:create)
          end

          install_via_gem_command(name, version)
          true
        end

        def install_via_gem_command(name, version)
          # Handle installing from a local file.
          if source_is_remote?
            src = @new_resource.source &&
              "  --source=#{@new_resource.source} --source=http://rubygems.org"
          else
            name = @new_resource.source
          end

          cmd = %{rvm #{ruby_strings.join(',')} #{rvm_do(gem_env.user)} #{gem_binary_path}}
          cmd << %{ install #{name} -q --no-rdoc --no-ri -v "#{version}"}
          cmd << %{#{src}#{opts}}

          if gem_env.user
            user_dir    = Etc.getpwnam(gem_env.user).dir
            environment = { 'USER' => gem_env.user, 'HOME' => user_dir }
          else
            user_dir    = nil
            environment = nil
          end

          shell_out!(rvm_wrap_cmd(cmd, user_dir), :env => environment)
        end

        def remove_package(name, version)
          uninstall_via_gem_command(name, version)
        end

        def uninstall_via_gem_command(name, version)
          cmd = %{rvm #{ruby_strings.join(',')} #{rvm_do(gem_env.user)} #{gem_binary_path}}
          cmd << %{ uninstall #{name} -q -x -I}
          if version
            cmd << %{ -v "#{version}"#{opts}}
          else
            cmd << %{ -a#{opts}}
          end

          if gem_env.user
            user_dir    = Etc.getpwnam(gem_env.user).dir
            environment = { 'USER' => gem_env.user, 'HOME' => user_dir }
          else
            user_dir    = nil
            environment = nil
          end

          shell_out!(rvm_wrap_cmd(cmd, user_dir), :env => environment)
        end
      end
    end
  end
end
