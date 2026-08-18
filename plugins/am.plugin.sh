#!/usr/bin/env bash
#!banager/plugin
# name = AppManager Plugin 
# version = 1.0.0
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = This is a plugin for the AM/AppMan appimage package manager
# source = https://codeberg.org/RubyRose/blugins/raw/branch/main/plugins/am.plugin.sh
# shellcheck disable=SC2154 source=/dev/null 
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/declare.sh"
if command -v am &>/dev/null || command -v appman &>/dev/null; then 
    working=true 
else 
    working=false
fi
if command -v curl &>/dev/null; then 
    grabber="curl -sLo"
    get_cmd="https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER"
elif command -v wget &>/dev/null; then 
    grabber="wget -q"
    get_cmd="./AM-INSTALLER https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER"
fi
if [ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/app.location.sh" ]; then 
    touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/app.location.sh"
    # shellcheck disable=SC2154
    echo -e "$env_allow\nWhere do you want to install user applications? "
    read -r app_locale
    # shellcheck disable=SC2154
    echo -e "$bash_declare\n$bash_gen\n$dont_delete\napp_locate=$app_locale" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/user/app.location.sh"
fi
# shellcheck disable=SC2154
echo "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/app.location.sh: app_locale is $app_locale" >> "$log_file"
if [ "$working" = "false" ]; then 
    $grabber "$get_cmd" && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER && rm ./AM-INSTALLER
fi
if command -v appman &>/dev/null && ! command -v am &>/dev/null; then 
    alias am=appman 
fi
