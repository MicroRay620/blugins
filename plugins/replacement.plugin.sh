#!/usr/bin/env bash
#!banager/plugin
# name = Replacement Commands 
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = A plugin to allow you to easily just have the commands be something findable
# source = https://codeberg.org/RubyRose/banager/raw/branch/main/plugins/nixos.plugin.sh
if command -v rg &>/dev/null; then 
    alias grep=rg
elif command -v rga &>/dev/null; then 
    alias grep=rga 
fi

if ! command -v dust &>/dev/null; then 
    alias du="du -sh"
fi

if command -v fd &>/dev/null; then 
    alias find="fd -tf -tl --show-errors --hidden --prune --exclude '.git node_modules'"
    alias fd="fd -tf -tl --show-errors --hidden --prune --exclude '.git node_modules'"
elif command -v find &>/dev/null; then 
    alias find="find -L"
fi

if command -v bat &>/dev/null; then 
    alias cat=bat 
fi

if command -v eza &>/dev/null; then 
    alias ls="eza -Gumn --all --no-permissions --no-quotes --icons=always --group-directories-first"
elif command -v ls &>/dev/null; then
    alias ls="ls -ChRskNp --all --time=access"
fi
alias please='$SUPER $(fc -ln -1)'
