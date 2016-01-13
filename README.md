# git-encrypt

Commit encrypted files that match patterns.

## Synopsis

git encrypt --install  
git encrypt --add-pattern <pattern>  
git encrypt --list-patterns  

## Installation

### Dependencies

The git-encrypt depends on the following libraries:

* aws-cli for AWS Key Management Service
* openssl for encryption and decryption

### Installing git encrypt

```git-encrypt``` must be placed somewhere PATH.

## Description

```git encrypt``` is transparent files encryption and decryption.  
If you add files to a git index. Encryption is completely transparent.  
If you checkout files from a git repository. Decryption is completely tranasparent.  
If you run ```git-diff```. It seems that was nat to encrypt.  

## Sub commands

```--install``` Installs filter settings and encryption options  for a repository.  
```--add-pattern <pattern>``` Adds <pattern> to become an object for encryption and decryption filters.  
```--list-patterns``` Shows list patterns to become an object for encryption and decryption filters.  



