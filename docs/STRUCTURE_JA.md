# リポジトリ構成

このドキュメントでは、git-encrypt-kms リポジトリの内容と各ディレクトリの役割について説明します。

## 主要なファイル・ディレクトリ

| パス | 概要 |
| ---- | ---- |
| `git-encrypt` | Git のフィルターとして動作するシェルスクリプト。本リポジトリの中心機能を提供します。 |
| `bats/` | テストフレームワーク Bats のサブモジュールです。 |
| `test/` | Bats を用いたテストスクリプトを配置しています。 |
| `README.md` | 基本的な利用方法や依存関係を記載したドキュメントです。 |

## git-encrypt スクリプト概要

`git-encrypt` は Bash スクリプトで、以下のような処理を行います。

1. `generate_encryption_key` で AWS KMS からデータキーを生成
2. `set_data_key` で git-encrypt-agent と連携し復号用キーを管理
3. `install` で Git フィルターの設定を追加
4. `configure` で AWS 関連の設定を保存
5. `clean` / `smudge` でファイルを暗号化・複合化

フィルター設定を行う `install` 関数の一部は次の通りです。

```bash
function install() {
  git config --replace-all merge.renormalize true
  git config --replace-all filter.git-encrypt.clean  "git-encrypt --clean"
  git config --replace-all filter.git-encrypt.smudge "git-encrypt --smudge"
  git config --replace-all diff.git-encrypt.textconv "git-encrypt --diff"
  add_attribute '.git* !filter !diff' $GIT_DIR/info/attributes
  configure
}
```

## テスト構成

`test/helper.bash` では一時的な Git リポジトリを作成してテストを実行するための関数を提供します。

```bash
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

```

`test/git-encrypt.bats` には `git-encrypt` コマンドの動作を確認するテストが含まれています。

```bash
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

```

テストは次のコマンドで実行できます。

```bash
$ ./bats/bin/bats test
```

## 利用方法

1. リポジトリをクローンし PATH を通します。
2. プロジェクトディレクトリで `git encrypt --install` を実行してフィルターを設定します。
3. 暗号化対象を `git encrypt --add-pattern` で登録します。
4. 以後 Git 操作時に自動で暗号化・複合化が行われます。

## おわりに

このリポジトリは AWS KMS を利用し、Git 管理下のファイルを透過的に暗号化する仕組みを提供します。テストには Bats を使用しています。
