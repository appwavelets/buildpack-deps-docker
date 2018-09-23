#!/bin/bash
set -eo pipefail

if [ ! -z "$KEY_PATH" ]; then
	# echo $KEY_PASSPHRASE |
	gpg --batch --import ${KEY_PATH}
fi

if [ ! -z "$GPG_KEY_NAME" ]; then
	sed -i -e "s/{{ GPG_KEY_NAME }}/$GPG_KEY_NAME/g" /root/.rpmmacros
	sed -i -e "s/{{ GPG_KEY_PASS }}/$GPG_KEY_PASS/g" /root/.rpmmacros
fi

exec "$@"
