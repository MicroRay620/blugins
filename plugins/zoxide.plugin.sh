#!/usr/bin/env bash
#!banager/plugin
# name = Zoxide Banager Plugin  
# owner = RubyRose 
# description = This is a plugin for zoxide in banager
# source = https://codeberg.org/RubyRose/blugins/src/branch/main/plugins/zoxide.plugin.sh
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/commands/declare.sh"

# shellcheck source=/dev/null
source -- "${XDG_CONFIG_HOME:-$HOME/.config}/banager/config.sh"
# shellcheck disable=SC2154
if [ "$dirmember" = "true" ]; then
    if command -v zoxide &>/dev/null; then 
        eval "$(zoxide init bash --cmd cd)"
    else
        echo -e "\e[31mBC1: You have the zoxide plugin but zoxide isn't installed.\e[0m" 
    fi
fi
