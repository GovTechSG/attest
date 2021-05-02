#!/bin/bash

public_key=$HOME/.gnupg/hashicorp.asc
tversion="$2"
terraform_sig=terraform_"$tversion"_SHA256SUMS.sig
terraform_sums=terraform_"$tversion"_SHA256SUMS
terraform=terraform_"$tversion"_darwin_amd64.zip
terraform_sig_url=https://releases.hashicorp.com/terraform/"$tversion"/"$terraform_sig"
terraform_sums_url=https://releases.hashicorp.com/terraform/"$tversion"/"$terraform_sums"
terraform_url=https://releases.hashicorp.com/terraform/"$tversion"/"$terraform"

tfenv_version_path=/usr/local/Cellar/tfenv/2.2.0/versions/"$tversion"
fifo_path=/tmp/fifo

gpg --import $public_key 2> /dev/null

curl -Os "$terraform_sig_url"
curl -Os "$terraform_sums_url"
curl -Os "$terraform_url"

if [ ! -p "$fifo_path" ]; then
       mkfifo "$fifo_path"
fi

# Verify the signature file is untampered.
verify_sig_file() {
	gpg --verify terraform_0.15.1_SHA256SUMS.sig terraform_0.15.1_SHA256SUMS 2>"$fifo_path" &
	chk_sig=$(tail "$fifo_path" | grep -c "Good signature")

	if [ "$chk_sig" -ne 1 ]; then
		echo "Signature file was tampered"
		exit 2
	fi
}

# Verify the SHASUM matches the archive.
verify_archive() {
	chk_sha=$(shasum -a 256 -c terraform_0.15.1_SHA256SUMS 2>/dev/null | grep terraform_0.15.1_darwin_amd64.zip | awk '{print $2}')

	if [ "$chk_sha" != "OK" ]; then
	       echo "Archive SHASUM does not match!"
	       exit 3
       else
	       echo "SHASUM matches the ${terraform}"
	fi	       
}

# Copy to tfenv path
tfenv_install() {
	tfenv_ver=$(tfenv -v | awk '{print $2}')
	tfenv_version_path=/usr/local/Cellar/tfenv/"$tfenv_ver"/versions/"$tversion"
	[ ! -d "$tfenv_version_path" ] && mkdir "$tfenv_version_path"
	set -vx
	tar xvfz $terraform -C $tfenv_version_path
}


# Help
help() {
cat << EOF
Usage: $0 terraform <verion number> install-tfenv

terraform <verion number>                  Terraform version number to download and attest
install-tfenv                              Install terraform to tfenv

EOF
exit;
}

case "$3" in
	install-tfenv)
		tf=true
		;;
	*)
		help
		;;
esac

case "$1" in
	terraform)
		if [ -z "$2" ]; then
			echo "Need to pass terraform version"
			exit 4
		fi

		verify_sig_file
		verify_archive

		rm $fifo_path

		if [ "$tf" == "true" ]; then
			tfenv_install
		fi
		;;
	*)
		help
		;;
esac