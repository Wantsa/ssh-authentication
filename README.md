This repository is for distributed PayWith staff SSH key management.

## Adding public keys

To have your SSH key added, please append your pubkey to the authorized_keys file with your email address as the tag and submit a pull request. EG:

     ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC3UIwaNVQfcnoKYi0qJYiaarazepRmZSvgQk8qMsrJxgoT62jgC8Y1RCku3zQjlqa6DHDublMZLvMtCNNkEEfw= sallen@paywith.com

## Setup

1. Clone this repository onto the target machine, then run the `initialize.sh` script as the login user (eg: `ec2-user`, `ubuntu`, etc). The repository can then be deleted.

2. Using `sudo crontab -e`, add this cronjob:
     */5 * * * * <HOME_DIRECTORY_OF_LOGIN_USER>/.ssh/rebase.sh >/dev/null 2>&1

