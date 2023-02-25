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
# ZSH                                                                         #
###############################################################################

if [ ! -d ${HOME}/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "ZSH already installed. Skipping!"
fi
