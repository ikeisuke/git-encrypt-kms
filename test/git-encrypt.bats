#!/usr/bin/env bats
load helper

@test "no arguments prints help" {
  repo_run git-encrypt
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "usage: git encrypt") -ne 0 ]
}

@test "-h prints help" {
  repo_run git-encrypt -h
  [ $(expr "${lines[0]}" : "usage: git encrypt") -ne 0 ]
}

# TODO
#@test "--help prints help" {
#}

@test "--install" {
  repo_run git-encrypt --install
  git-encrypt --install
  [ $status -eq 1 ]
}
