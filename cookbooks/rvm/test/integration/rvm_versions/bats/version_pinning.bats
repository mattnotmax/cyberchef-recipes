#!/usr/bin/env bats

@test "virgil1 user has rvm-1.17.10" {
  run sudo -u virgil1 -i rvm version
  [ $status -eq 0 ]
  [ "$(echo $output | awk '{print $2}')" = "1.17.10" ]
}

@test "virgil2 user has rvm-1.16.20" {
  run sudo -u virgil2 -i rvm version
  [ $status -eq 0 ]
  [ "$(echo $output | awk '{print $2}')" = "1.16.20" ]
}
