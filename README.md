This repository is for distributed PayWith staff SSH key management.

## Adding public keys

To have your SSH key added, please append your pubkey to the authorized_keys file with your email address as the tag and submit a pull request. EG:

     ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC3UIwaNVQfcnoKYi0qJYiaarazepRmZSvgQk8qMsrJxgoT62jgC8Y1RCku3zQjlqa6DHDublMZLvMtCNNkEEfw= sallen@paywith.com

## Setup

Easy setup for Ubuntu servers:

    wget -O - https://raw.githubusercontent.com/Wantsa/ssh-authentication/two-factor/initialize.sh | bash
