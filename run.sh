#! /bin/bash -x

set -e

if [ "$1" = '/usr/sbin/sshd' ]; then

  if [[ -z "$SSH_KEY" ]]; then
    echo "SSH_KEY env var is empty. Please set this in the environment."
    exit 1
  fi

  if [[ -z "$RELEASE_BRANCH" ]]; then
    RELEASE_BRANCH=master
    echo "RELEASE_BRANCH env var is empty. Using default ('$RELEASE_BRANCH')."
  fi

  if [[ -z "$RELEASE_SRC" ]]; then
    RELEASE_SRC=""
    echo "RELEASE_SRC env var is empty. Using default ('$RELEASE_SRC')."
  fi

  if [[ -z "$RELEASE_DEST" ]]; then
    RELEASE_DEST=/home/git/release
    echo "RELEASE_DEST env var is empty. Using default ('$RELEASE_DEST')."
  fi

  authorized_keys=/home/git/.ssh/authorized_keys
  echo "$SSH_KEY" > "$authorized_keys"
  chmod 600 "$authorized_keys"
  chown git:git "$authorized_keys"

  if [ ! -d "$RELEASE_DEST" ]; then
    mkdir -p "$RELEASE_DEST"
  fi
  chown -R git:git "$RELEASE_DEST"
  echo "RELEASE_BRANCH=${RELEASE_BRANCH}" > /home/git/post-receive.env
  echo "RELEASE_SRC=${RELEASE_SRC}" >> /home/git/post-receive.env
  echo "RELEASE_DEST=${RELEASE_DEST}" >> /home/git/post-receive.env

  echo "Starting ssh server..."
  /usr/sbin/sshd -D

else

  exec "$@"

fi
