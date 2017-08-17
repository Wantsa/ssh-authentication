#!/bin/bash
TARGET_USER=ec2-user
sudo -u $TARGET_USER cd ~

echo "Switched to $TARGET_USER"

# Clone the repo and move it to the appropriate directory
yum install –y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install pam_yubico ruby git -y

TMP_GIT_GARGET=/tmp/ssh-authentication/

sudo -u $TARGET_USER -H git clone https://github.com/Wantsa/ssh-authentication.git $TMP_GIT_GARGET
sudo -u $TARGET_USER -H rsync -ac $TMP_GIT_GARGET /home/$TARGET_USER/.ssh/
sudo -u $TARGET_USER -H rm -rf $TMP_GIT_GARGET


sudo -u $TARGET_USER -H sudo /home/$TARGET_USER/.ssh/rebase.sh

# Add the Yubikey PAM module configs to ssh logins

sed -i -e '1iauth sufficient pam_yubico.so cue interactive id=33507 key=5VsuxjBpHdR+Xz36GVSlnxQv67U= authfile=/home/$TARGET_USER/.ssh/yubikey_mappings mode=client\n' /etc/pam.d/sshd

# Update the SSH config

perl -i.original -pe 's/^ChallengeResponseAuthentication (yes|no)/ChallengeResponseAuthentication yes\nAuthenticationMethods publickey,keyboard-interactive:pam\n/gm' /etc/ssh/sshd_config
service sshd reload


# Append the cron job to the root user's crontab, creating one if it does not exist:

command="/home/$USER/.ssh/rebase.sh >/dev/null 2>&1"
job="*/5 * * * * $command"
cat <(fgrep -i -v "$command" <(sudo -u $TARGET_USER -H crontab -l)) <(echo "$job") | sudo -u $TARGET_USER -H crontab -