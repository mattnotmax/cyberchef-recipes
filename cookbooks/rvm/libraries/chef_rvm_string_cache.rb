#
# Cookbook Name:: rvm
# Library:: Chef::RVM::StringCache
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

require 'chef/mixin/command'

class Chef
  module RVM
    module ShellHelpers
      # stub to satisfy StringCache (library load order not guarenteed)
    end

    class StringCache
      class << self
        include Chef::Mixin::Command
        include Chef::RVM::ShellHelpers
      end

      ##
      # Returns a fully qualified RVM Ruby string for the given input string
      #
      # @param [String] a string that can interpreted by RVM
      # @param [String] the username if this is for a user install or nil if
      #                 it is a system install
      # @return [String] a fully qualified RVM Ruby string
      def self.fetch(str, user = nil)
        @@strings ||= Hash.new
        rvm_install = user || "system"
        @@strings[rvm_install] ||= Hash.new

        return @@strings[rvm_install][str] if @@strings[rvm_install].has_key?(str)

        result = canonical_ruby_string(str, user)
        # cache everything except default environment
        if str == 'default'
          result
        else
          @@strings[rvm_install][str] = result
        end
      end

      protected

      def self.canonical_ruby_string(str, user)
        Chef::Log.debug("Fetching canonical RVM string for: #{str} " +
                        "(#{user || 'system'})")
        if user
          user_dir = Etc.getpwnam(user).dir
        else
          user_dir = nil
        end

        cmd = ["source #{find_profile_to_source(user_dir)}",
          "rvm_ruby_string='#{str}'", "__rvm_ruby_string",
          "echo $rvm_ruby_string"].join(" && ")
        pid, stdin, stdout, stderr = popen4('bash', shell_params(user, user_dir))
        stdin.puts(cmd)
        stdin.close

        result = stdout.read.split('\n').first.chomp
        if result =~ /^-/   # if the result has a leading dash, value is bogus
          Chef::Log.warn("Could not determine canonical RVM string for: #{str} " +
                         "(#{user || 'system'})")
          nil
        else
          Chef::Log.debug("Canonical RVM string is: #{str} => #{result} " +
                          "(#{user || 'system'})")
          result
        end
      end

      def self.shell_params(user, user_dir)
        if user
          {
            :user => user,
            :environment => {
              'USER' => user,
              'HOME' => user_dir
            }
          }
        else
          Hash.new
        end
      end
    end
  end
end
