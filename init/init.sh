#!/usr/bin/env bash

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
cp -r VSCode/. ${HOME}/Library/Application\ Support/Code/User/

# make sure to install extensions too
## important ones
# Dracula
# Markdown All in One
# Prettier
# Sublime Text Keymaps

###############################################################################
# ZSH                                                                         #
###############################################################################

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
