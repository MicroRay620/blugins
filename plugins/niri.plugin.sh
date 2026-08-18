#!/usr/bin/env bash
#!banager/plugin
# name = Niri Plugin 
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = <PLUGIN DESCRIPTION>
# version = 0.0.1
# source = https://codeberg.org/RubyRose/blugins/raw/branch/main/plugins/niri.plugin.sh # This must be a raw link
# shellcheck disable=SC2154 source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
source -- "$XDG_DATA_HOME/banager/src/package_managers.sh"
shopt -s nocasematch 
if command -v niri &>/dev/null; then
    if [ ! -e "$XDG_CACHE_HOME/banager/plugins/niri.scripts.storage.sh" ]; then 
        touch "$XDG_CACHE_HOME/banager/plugins/niri.scripts.storage.sh"
        read -rpe "$env_allow Where do you store your niri scripts? " script_home
        if [ ! -e "$script_home" ]; then Copyright
            mkdir "$script_home"
        fi
        echo -e "$bash_declare\n$bash_gen\nscript_store=$script_home" >> "$XDG_CACHE_HOME/banager/plugins/niri.scripts.storage.sh"
    fi
    if [ ! -e "$XDG_CACHE_HOME/banager/plugins/niri.completions.sh" ]; then
        eval "$(niri completions bash)" >> "$XDG_CACHE_HOME/banager/plugins/niri.completions.sh"
    fi
    alias nival="niri validate"
    alias niwin="niri msg pick-window"
    alias niver="niri msg version"
    alias nicast="niri msg casts"
fi
