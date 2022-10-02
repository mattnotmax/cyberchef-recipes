#
# Cookbook Name:: rvm
# Library:: Chef::RVM::ShellHelpers
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
      ##
      # Finds the correct shell profile to source to init an RVM-aware
      # shell environment
      #
      # @param [String] a user's home directory path if this is for a user or
      #                 nil if it is in a system context
      # @return [String] full path the shell profile
      def find_profile_to_source(user_dir = nil)
        if user_dir
          "#{user_dir}/.rvm/scripts/rvm"
        else
          if ::File.directory?("/etc/profile.d")
            "/etc/profile.d/rvm.sh"
          else
            "/etc/profile"
          end
        end
      end

      ##
      # Returns a shell command that is RVM-aware
      #
      # @param [String, #to_s] the shell command to be wrapped
      # @param [String] A user's home directory path if this is for a user or
      #                 nil if it is in a system context
      # @return [String] the command wrapped in RVM-initialized bash command
      def rvm_wrap_cmd(cmd, user_dir = nil)
        profile = find_profile_to_source(user_dir)
        %{bash -c "source #{profile} && #{cmd.gsub(/"/, '\"')}"}
      end
    end
  end
end
