class Chef
  module RVM
    module SetHelpers
      def rvm_do(user = nil)
        # Use Gem's version comparing code to compare the two strings
        rvm_version = VersionCache.fetch_version(user).gsub(/(-|_|#)/, '.')
        if Gem::Version.new(rvm_version) < Gem::Version.new("1.8.6")
          "exec"
        else
          "do"
        end
      end

    end
  end
end
