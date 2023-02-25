#!/usr/bin/env bash

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# create symlink
## create a symlink since it's easier / more discoverable to edit from home dir
ln -s ${HOME}/Projects/Personal/dotfiles ${HOME}/dotfiles

# create project directories
CODE=${HOME}/Projects

mkdir -p $CODE
mkdir -p ${CODE}/Personal
mkdir -p ${CODE}/Work

###############################################################################
# VSCode                                                                      #
###############################################################################

# move VSCode settings
mkdir -p ${HOME}/Library/Application\ Support/Code/User/
cp -r ${SCRIPT_DIR}/VSCode/. ${HOME}/Library/Application\ Support/Code/User/

# make sure to install extensions too
## important ones
# Dracula
# Markdown All in One
# Prettier
# Sublime Text Keymaps
## Fonts
# Source Code Pro

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
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

echo "Please make sure to add these credentials to Github"
open https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

###############################################################################
# Homebrew                                                                    #
###############################################################################

which -s brew
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "brew is installed. Skipping!"
fi

###############################################################################
# ZSH                                                                         #
###############################################################################

if [ ! -d ${HOME}/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "ZSH already installed. Skipping!"
fi

###############################################################################
# Applications                                                                #
# https://github.com/mas-cli/mas >> could be useful?
###############################################################################
echo "Make sure to install these applications (./init/applications.txt):"
cat ${SCRIPT_DIR}/applications.txt

echo "✅ And we're done. Thanks!"