#!/bin/sh


logger ssh-authentication "Checking if authorized_keys needs to be updated"
cd "$(dirname "$0")"
git fetch origin --quiet
CHANGED_FILES=$(git rev-list HEAD...origin/two-factor --count)
BASE=$(git rev-parse origin/two-factor)

ruby build_mappings.rb

if [ $CHANGED_FILES -gt 0 ]; then
  logger ssh-authentication "Updating authorized_keys (git commit $BASE)"
  git fetch
  git reset --hard origin/two-factor
  logger ssh-authentication "Kicking active SSH sessions"

  SSH_SERVICE=sshd

  if [ -f /etc/debian_version ]; then
    SSH_SERVICE=ssh
  fi

  sudo service $SSH_SERVICE stop
  sudo service $SSH_SERVICE start
else
  logger ssh-authentication "Nope, authorized_keys is cool just the way it is"
fi

chmod 600 authorized_keys
