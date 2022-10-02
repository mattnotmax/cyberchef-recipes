name             "openssl"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Provides a library with a method for generating secure random passwords."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.1"

recipe "openssl", "Empty, this cookbook provides a library, see README.md"
