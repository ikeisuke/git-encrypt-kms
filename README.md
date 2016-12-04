# git-encrypt-kms

git管理しているファイルを透過的に暗号化、複合化するためのフィルター

## Synopsis

git encrypt --install  
git encrypt --add-pattern <pattern>  

## システムへのインストール

リポジトリをcloneし、PATHを通すだけです。  
もしくはリポジトリ内のgit-encryptファイルをパスの通った場所に設置します。

```bash
$ git clone https://github.com/ikeisuke/git-encrypt-kms.git
$ PATH=$PATH:/path/to/git-encrypt-kms
```

### Dependencies

The git-encrypt depends on the following libraries:

* [aws-cli](https://aws.amazon.com/jp/cli/)
  * ファイルの複合化のためにはデータキー用のKMSのキーに対する kms:Decrypt 権限が必要です
  * データキーを作成するには対象のKMSのキーに対する kms:GenerateDataKeyWithoutPlaintext 権限が必要です
* [git-encryt-agent](https://github.com/ikeisuke/git-encrypt-agent/)


## プロジェクトへのインストール

全てのユーザーが対象のプロジェクトでそれぞれ実行する必要があります。

デフォルトプロファイルを利用し、リージョンのデフォルト設定をしている場合にはprofile, regionの入力は不要です。  
また、KMSのキーはデータキーを作成する最初のユーザーのみが入力を求められます。  

```
$ cd /path/to/git-repo-dir
$ git encrypt --install
Input your aws profile []:
Input region to use []:
Input Specified key for AWS KMS []:
```

### 暗号化対象ファイルの指定

暗号化対象ファイルをコマンドから指定します。

```
$ cd /path/to/git-repo-dir
$ git encrypt --add-pattern path/to/file
```

`*`を使いたい場合には必ず''で囲んでください。

```
$ git encrypt --add-pattern 'path/to/dir/*'
```

### ファイルの暗号化(パターン追加後初回のみ)

暗号化したいファイルがすでにプロジェクト内にある場合にはindexファイルをリセットします。  
未編集のファイルも暗号化のために編集中マークがつくので、作業の前に必要に応じて編集を退避するなどしてください。  
これ以降は暗号化・複合化は透過的に行われます。  

```
$ rm -f .git/index
$ git reset
$ git add .
$ git commit -m 'Encryption'
```

### ファイルの複合化(新規にcloneした直後)

すでに暗号化されたファイルがコミット済みの場合で、複合化を行いたい場合はハードリセットを行います。  
ハードリセットにより編集中のファイルは全てリセットされるので、　作業の前に必要に応じて編集を退避するなどしてください。  
これ以降は暗号化・複合化は透過的に行われます。  

```
$ git reset --hard
```

### 暗号化・複合化の確認方法

コミットしたデータが暗号化されているかは、対象のリポジトリを別の場所にcloneすることで確認できます。

```
$ git clone /path/to/git-repo-dir git-repo-dir-test
$ cd git-repo-dir-test
$ cat path/to/encrypted_file # ここで暗号化されていればOK
$ git encrypt --install
$ git reset --hard
$ cat path/to/encrypted_file # ここで複合化されていればOK
```
