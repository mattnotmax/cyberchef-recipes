class Chef
  module RVM
    module ShellHelpers
      # stub to satisfy VersionCache (library load order not guarenteed)
    end

    module VersionHelpers
      def rvm_version(user = nil)
        VersionCache.fetch_version(user)
      end
    end

    class VersionCache
      class << self
        include Chef::Mixin::ShellOut
        include Chef::RVM::ShellHelpers
      end

      def self.fetch_version(user = nil)
        @@versions ||= Hash.new
        rvm_install = user || "system"
        @@versions[rvm_install] ||= rvm_version(user)
      end

      def self.rvm_version(user = nil)
        cmd = "rvm version | cut -d ' ' -f 2"

        if user
          user_dir    = Etc.getpwnam(user).dir
          environment = { 'USER' => user, 'HOME' => user_dir }
        else
          user_dir    = nil
          environment = nil
        end

        version = shell_out!(
          rvm_wrap_cmd(cmd, user_dir), :env => environment).stdout.strip

        Chef::Log.debug "RVM version = #{version} (#{user || 'system'})"

        version
      end
    end
  end
end
