#!/usr/bin/env bash
#!banager/plugin
# name = AppManager Plugin 
# owner = RubyRose
# description = This is a plugin for the AM/AppMan appimage package manager
# source = https://codeberg.org/RubyRose/blugins/src/branch/main/plugins/am.plugin.sh
# shellcheck source=/dev/null 
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/declare"
am_list=( "am" "appman" )
grabs=( "curl" "wget" )
for app in "${am_list[@]}"; do 
    if $app &>/dev/null; then
        working="true"
    else
        working="false"
    fi
done
for grab in "${grabs[@]}"; do 
    if command -v "$grab" &>/dev/null; then 
        grabber="$grab" 
    fi
done
if [ "$grabber" = "curl" ]; then 
    grabber="curl -sLO"
    get_cmd="https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER"
elif [ "$grabber" = "wget" ]; then 
    grabber="wget -q"
    get_cmd="./AM-INSTALLER https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER"
fi
if [ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/banager/user/app.location.sh" ]; then 
    touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/user/app.location.sh"
    # shellcheck disable=SC2154
    echo -e "$env_allow\nWhere do you want to install user applications? "
    read -r app_locale
    # shellcheck disable=SC2154
    echo -e "$bash_declare\n$bash_gen\n$dont_delete\napp_locate=$app_locale" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/user/app.location.sh"
fi
if [ "$working" = "false" ]; then 
    $grabber "$get_cmd" && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER && rm ./AM-INSTALLER
fi
if command -v appman &>/dev/null && ! command -v am &>/dev/null; then 
    alias am=appman 
fi
