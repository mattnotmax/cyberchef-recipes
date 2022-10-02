#!/usr/bin/env bats

rubie="1.9.3"

load _common

@test "RVM $rubie can use nokogiri with openssl" {
  run_nokogiri_openssl_test $rubie
}
