#!/usr/bin/env bats

rubie="1.8.7"

load _common

@test "RVM $rubie can use nokogiri with openssl" {
  run_nokogiri_openssl_test $rubie
}

@test "Installs RubyGems 1.6.0 in RVM $rubie" {
  run rvm 1.8.7 do gem --version
  [ "$status" -eq 0 ]
  [ "$output" = "1.6.0" ]
}
