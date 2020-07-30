#!/usr/bin/env bash

#------------------------------------------------------------------------------#
#                           Dotfiles - run this first                          #
#------------------------------------------------------------------------------#
# git clone https://github.com/kazhala/dotbare.git ~/.dotbare
# source ~/.dotbare/dotbare.plugin.zsh
# dotbare finit -u git@github.com:jlorince/dotfiles.git

#------------------------------------------------------------------------------#
#                                   Homebrew                                   #
#------------------------------------------------------------------------------#
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle --global
# Setup additional FZF stuff
$(brew --prefix)/opt/fzf/install


