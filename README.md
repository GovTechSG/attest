# attest

attest is a tool for downloading terraform and verify that the SHASUM matches the archive.

## What is actually run in the back background

1. Import hashicorp public key using gpg
2. Download the archive, SHA256SUM, and SHA256SUM.sig files
3. Verify is signature file is not tampered with
4. Verify the SHASUM matches the archive
5. Install to tfenv if argument "install-tfenv" was passed to command

## Prerequiste

1. gpg - OpenPGP encryption and signing tool

## How to setup

1. Download Hashicorp public key from https://www.hashicorp.com/security
2. Store Hashicorp public key from step 2 to $HOME/.gnupg/hashicorp.asc
3. `git clone <attest_repo_url>`
4. `ln -s /<path_to_attest_repo>/attest.sh /usr/local/bin/attest`

## Usage

```bash
Example:
# Download and verify terraform package
Usage: attest terraform <verion number>

# Deploy package to tfenv
Usage: attest terraform <verion number> install-tfenv

terraform <verion number>                  Terraform version number to download and attest (eg. 0.15.4)
install-tfenv                              Install terraform to tfenv
```
