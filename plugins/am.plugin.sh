#!/usr/bin/env bash
#!banager/plugin
# name = AppManager Plugin 
# owner = RubyRose
# description = This is a plugin for the AM/AppMan appimage package manager
# source = https://codeberg.org/RubyRose/banager/src/branch/main/plugins/am.plugin.sh
# AM is an appimage package manager
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
if [[ "$working" = "false" ]]; then 
   $grabber "$get_cmd" && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER && rm ./AM-INSTALLER
fi
