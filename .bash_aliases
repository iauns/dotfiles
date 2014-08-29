#!/usr/bin/env bash

# Be sure to run .apt in dotfiles in order to find necessary scripts
export TERM=screen-256color
export PATH=$PATH:$HOME/sw/bin
export P4CONFIG=$HOME/.p4settings
alias g='git'

if [[ -e /usr/share/autojump ]]; then
  . /usr/share/autojump/autojump.bash
fi
