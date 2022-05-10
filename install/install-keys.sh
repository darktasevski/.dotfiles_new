#!/bin/bash

if [[ -d "$SECURE_STORAGE" ]]; then
	ln -sfv "$SECURE_STORAGE"/ssh "$HOME"/.ssh
	ln -sfv "$SECURE_STORAGE"/gnupg "$HOME"/.gnupg

	# @see https://gist.github.com/oseme-techguy/bae2e309c084d93b75a9b25f49718f85
	# To fix the " gpg: WARNING: unsafe permissions on homedir '/home/path/to/user/.gnupg' " error
	# Make sure that the .gnupg directory and its contents is accessibile by your user.
	chown -R $(whoami) ~/.gnupg/

	# Also correct the permissions and access rights on the directory
	chmod 600 ~/.gnupg/*
	chmod 700 ~/.gnupg
else
	echo "No secure storage found"
fi

# @see https://docs.github.com/en/authentication/managing-commit-signature-verification/associating-an-email-with-your-gpg-key
# to add additional uid(s) to the existing GPG key

# to export gpg keys data:
# gpg --export-secret-keys > sec.gpg
# to import gpg keys data on new machine
# gpg --import sec.gpg

# to set trust level of imported keys
# gpg --edit-key {KEY} trust quit
  # enter 5<RETURN> (I trust ultimately)
  # enter y<RETURN> (Really set this key to ultimate trust - Yes)

# restart gpg agent
# gpgconf --kill gpg-agent