#!/usr/bin/env bash
#!banager/plugin
# name = Starship Banager Plugin 
# owner = RubyRose
# description = This enables starship on your system
# source = https://codeberg.org/RubyRose/blugins/src/branch/main/plugins
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
source -- "${XDG_CONFIG_HOME:-$HOME/.config}/banager/config.sh"
# shellcheck disable=SC2154
if [ "$starship" = "true" ]; then
    if command -v starship &>/dev/null; then 
        if [ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/banager/starship.completion.sh" ]; then 
            touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/starship.completion.sh"
            starship completions bash >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/starship.completion.sh"
            source -- "${XDG_CACHE_HOME:-$HOME/.cache}/banager/starship.completion.sh"
        else 
            source -- "${XDG_CACHE_HOME:-$HOME/.cache}/banager/starship.completion.sh"
        fi
        if [ ! -e "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml" ]; then
            touch "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
            starship preset bracketed-segments >> "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
            echo "To change your preset for starship, either look at the starship documentation or run \`\$ starship preset\ <PRESET OPTION> >> ~/.config/starship.toml\`"
            eval "$(starship init bash)"
        else 
            eval "$(starship init bash)"
        fi
    fi
fi
