maintainer       "Promet Solutions"
maintainer_email "marius@promethost.com"
license          "Apache 2.0"
description      "Installs/Configures nodejs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.3.0"
name             "nodejs"
provides         "nodejs"

recipe "nodejs", "Installs Node.JS based on the default installation method"
recipe "nodejs::install_from_source", "Installs Node.JS from source"
recipe "nodejs::install_from_binary", "Installs Node.JS from official binaries"
recipe "nodejs::install_from_package", "Installs Node.JS from packages"
recipe "nodejs::npm", "Installs npm from source - a package manager for node"

%w{ apt yum build-essential }.each do |c|
  depends c
end

%w{ debian ubuntu centos redhat smartos }.each do |os|
    supports os
end
