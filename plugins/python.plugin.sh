#!/usr/bin/env bash
#!banager/plugin
# name = Template 
# owner = RubyRose 
# license = CC BY-SA 4.0 International
# description = Makes python commands work for you
# version = 0.0.1
# source = https://codeberg.org/RubyRose/blugins/raw/branch/main/plugins/python.plugin.sh # This must be a raw link
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
shopt -s nocasematch 
if command -v python &>/dev/null; then 
    if command -v pipx &>/dev/null; then 
        alias pxadd='pipx install --include-deps'
        alias pxaddall='pipx install-all'
        alias pxrm='pipx uninstall --include-deps'
        alias pxup='pipx update'
        alias pxreadd='pipx reinstall --include-deps'
        alias pxpin='pipx pin'
        alias pxls='pipx list'
        eval "$(register-python-argcomplete pipx)"
    # TODO: Add the pip aliases
    fi
fi
