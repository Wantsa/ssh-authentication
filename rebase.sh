#!/bin/sh
cd "$(dirname "$0")"

BRANCH=$(git symbolic-ref --short HEAD)
logger ssh-authentication "Checking if authorized_keys needs to be updated"
git fetch origin --quiet
CHANGED_FILES=$(git rev-list HEAD...origin/$BRANCH --count)
BASE=$(git rev-parse origin/$BRANCH)

ruby build_mappings.rb

if [ $CHANGED_FILES -gt 0 ]; then
  logger ssh-authentication "Updating authorized_keys (git commit $BASE)"
  git fetch
  git reset --hard origin/$BRANCH
  logger ssh-authentication "Kicking active SSH sessions"

  SSH_SERVICE=sshd

  if [ -f /etc/debian_version ]; then
    SSH_SERVICE=ssh
  fi

  sudo pkill -HUP sshd
  sudo service $SSH_SERVICE start
  logger ssh-authentication "SSH sessions kicked"
else
  logger ssh-authentication "Nope, authorized_keys is cool just the way it is"
fi

chmod 600 authorized_keys
