# attest

attest is a tool for downloading terraform and verify that the SHASUM matches the archive.

## What is actually run in the back background
1. Import hashicorp public key using gpg
2. Download the archive, SHA256SUM, and SHA256SUM.sig files
3. Verify is signature file is untamper
4. Verify the SHASUM matches the archive
5. Install to tfenv if argument "install-tfenv" was passed to command 

## Prerequiste
1. gpg - OpenPGP encryption and signing tool

## How to setup
1. Download hashicorp public key from https://www.hashicorp.com/security
2. Store hashicorp public key from step 2 to $HOME/.gnupg/hashicorp.asc
3. git clone <attest repo>
4. ln -s /usr/local/bin/attest <attest repo>/attest.sh

## Usage
```bash
Usage: attest terraform <verion number> install-tfenv

terraform <verion number>                  Terraform version number to download and attest
install-tfenv                              Install terraform to tfenv
```