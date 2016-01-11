#!/bin/bash
export TEST_REPO="$BATS_TMPDIR/test-repo"
INITIAL_PATH="${PATH}"

setup() {
  setup_repo
  export PATH="${BATS_TEST_DIRNAME}/..:${INITIAL_PATH}"
  cd $TEST_REPO
}

teardown() {
  delete_repo
  export PATH="${INITIAL_PATH}"
}

delete_repo() {
  [ -d $TEST_REPO ] && rm -rf $TEST_REPO || true
}

setup_repo() {
  delete_repo
  mkdir -p $TEST_REPO
  cd $TEST_REPO
  git init
  cd -
}

repo_run() {
  cmd="$1"
  shift
  cd "${TEST_REPO}"
  run $cmd $@
  cd -
}

