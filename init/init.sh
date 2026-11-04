#!/usr/bin/env bash

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_DIR=$( dirname -- "$SCRIPT_DIR" )

# create symlink
## create a symlink since it's easier / more discoverable to edit from home dir
ln -s ${HOME}/Projects/Personal/dotfiles ${HOME}/dotfiles

# create project directories
CODE=${HOME}/Projects

mkdir -p $CODE
mkdir -p ${CODE}/Personal
mkdir -p ${CODE}/Work
mkdir -p ${CODE}/Scripts
mkdir -p ${HOME}/.config/ghostty

###############################################################################
# Scripts                                                                     #
###############################################################################
cp -r ${REPO_DIR}/scripts/. ${CODE}/Scripts
cp ${REPO_DIR}/ghostty_config ${HOME}/.config/ghostty/config

###############################################################################
# Git Setup                                                                   #
###############################################################################

SSH_FILE=${HOME}/.ssh/config

ssh-keygen -t ed25519 -C "dustinschau@gmail.com"
eval "$(ssh-agent -s)"

if [ ! -f "$SSH_FILE" ]; then
  touch $SSH_FILE
else
  echo "~/.ssh/config exists"
fi

cat <<EOF >> $SSH_FILE
# Cloudflare Tunnel
Host ssh.dschau.dev
  ProxyCommand /opt/homebrew/bin/cloudflared access ssh --hostname %h

# GitHub
Host github.com
  IgnoreUnknown UseKeychain
  AddKeysToAgent yes
  # UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# cloudflared (the ProxyCommand above) writes its Access token/JWKS cache to ~/.cloudflared.
# If that dir was ever created by `sudo cloudflared ...` it's root-owned and ssh fails with
# "permission denied" / "Connection closed by UNKNOWN port 65535".
CLOUDFLARED_DIR=${HOME}/.cloudflared
mkdir -p "$CLOUDFLARED_DIR"
if [ -n "$(find "$CLOUDFLARED_DIR" ! -user "$(id -u)" -print -quit)" ]; then
  echo "Fixing ownership of $CLOUDFLARED_DIR (needs sudo)"
  sudo chown -R "$(id -u)":"$(id -g)" "$CLOUDFLARED_DIR"
fi
chmod 700 "$CLOUDFLARED_DIR"

# Create connection with remote PC
## does not require password when ssh'ing to htpc
## runs after ~/.ssh/config has the Cloudflare ProxyCommand; times out instead of hanging
ssh-copy-id -o ConnectTimeout=15 -i ~/.ssh/id_ed25519.pub dschau@ssh.dschau.dev \
  || echo "WARNING: ssh-copy-id to ssh.dschau.dev failed; re-run later: ssh-copy-id -i ~/.ssh/id_ed25519.pub dschau@ssh.dschau.dev"

echo "Please make sure to add these credentials to Github"
open https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

###############################################################################
# ZSH                                                                         #
###############################################################################

if [ ! -d ${HOME}/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "ZSH already installed. Skipping!"
fi


###############################################################################
# NVM / Node                                                                         #
###############################################################################

if [[ $(command -v nvm) == "" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

###############################################################################
# Bun                                                                         #
###############################################################################
if [[ $(command -v bun) == "" ]]; then
curl -fsSL https://bun.sh/install | bash
fi

echo "✅ And we're done. Thanks!"
