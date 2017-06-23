#!/bin/bash

cd ~

# Clone the repo and move it to the appropriate directory

git clone https://github.com/Wantsa/ssh-authentication.git
rsync -ac ./ssh-authentication/ ~/.ssh/

sudo add-apt-repository -y ppa:yubico/stable
sudo apt-get update && sudo apt-get install -y libpam-yubico ruby

sudo ~/.ssh/rebase.sh

# Add the Yubikey PAM module configs to ssh logins

sudo sed -i -e '1iauth sufficient pam_yubico.so cue interactive id=33507 key=5VsuxjBpHdR+Xz36GVSlnxQv67U= authfile=/home/ubuntu/.ssh/yubikey_mappings mode=client\n' /etc/pam.d/sshd

# Update the SSH config

sudo perl -i.original -pe 's/^ChallengeResponseAuthentication (yes|no)/ChallengeResponseAuthentication yes\nAuthenticationMethods publickey,keyboard-interactive:pam\n/gm' /etc/ssh/sshd_config
sudo service ssh reload


# Append the cron job to the root user's crontab, creating one if it does not exist:

sudo -S bash -c '\echo "*/5 * * * * /home/$USER/.ssh/rebase.sh >/dev/null 2>&1" >> /var/spool/cron/crontabs/root'


