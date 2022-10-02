#!/usr/bin/env bats

rubie="1.9.3-p327-railsexpress"

load _common

@test "RVM $rubie can use nokogiri with openssl" {
  run_nokogiri_openssl_test $rubie
}

# For more details, please see:
# https://github.com/fnichol/chef-rvm/pull/137#issuecomment-12258247
@test "RVM $rubie can use patched functionality" {
  script="puts Thread.current.thread_variable_set :foo, 'bar'"

  run rvm $rubie do ruby -e "$script"
  [ "$status" -eq 0 ]
  [ "$output" = "bar" ]
}
