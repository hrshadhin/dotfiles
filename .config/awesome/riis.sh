#!/usr/bin/env bash
shopt -s expand_aliases

# Run interactive shell for aliased cmd
source ~/.config/zsh/alias.zsh
eval "$@"
