#!/bin/bash
set -eo pipefail

if [ ! -z "$GPG_KEY_PATH" ]; then

	if [ -z "$GPG_KEY_ID" ] || [ -z "$GPG_KEY_PASS" ]; then
		echo "Error: missing GPG_KEY_ID or GPG_KEY_PASS!" 1>&2
		exit 1
	else
		sed -i -e "s/{{ GPG_KEY_ID }}/$GPG_KEY_ID/g" /root/.rpmmacros
		sed -i -e "s/{{ GPG_KEY_PASS }}/$GPG_KEY_PASS/g" /root/.rpmmacros
	fi
	gpg --batch --import ${GPG_KEY_PATH}
fi

exec "$@"
