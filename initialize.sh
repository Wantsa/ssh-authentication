#!/bin/bash
TARGET_USER=`whoami`
cd ~

# Clone the repo and move it to the appropriate directory

git clone -b two-factor https://github.com/Wantsa/ssh-authentication.git
rsync -ac ./ssh-authentication/ ~/.ssh/
rm -rf ./ssh-authentication

sudo add-apt-repository -y ppa:yubico/stable
sudo apt-get update && sudo apt-get install -y libpam-yubico ruby

~/.ssh/rebase.sh

# Add the Yubikey PAM module configs to ssh logins

sudo sed -i -e '1iauth sufficient pam_yubico.so cue interactive id=33507 key=5VsuxjBpHdR+Xz36GVSlnxQv67U= authfile=/home/ubuntu/.ssh/yubikey_mappings mode=client\n' /etc/pam.d/sshd

# Update the SSH config

sudo perl -i.original -pe 's/^ChallengeResponseAuthentication (yes|no)/ChallengeResponseAuthentication yes\nAuthenticationMethods publickey,keyboard-interactive:pam\n/gm' /etc/ssh/sshd_config
sudo service ssh reload


# Append the cron job to the root user's crontab, creating one if it does not exist:

command="/home/$TARGET_USER/.ssh/rebase.sh >/dev/null 2>&1"
job="*/5 * * * * $command"
cat <(fgrep -i -v "$command" <(sudo -u $TARGET_USER -H crontab -l)) <(echo "$job") | sudo -u $TARGET_USER -H crontab -

