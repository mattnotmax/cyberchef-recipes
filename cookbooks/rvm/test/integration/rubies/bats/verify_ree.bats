#!/usr/bin/env bats

export rubie="ree"

load _common

@test "RVM $rubie can use nokogiri with openssl" {
  run_nokogiri_openssl_test $rubie
}
