#!/usr/bin/env bash
#!banager/plugin
# name = Replacement Commands 
# owner = RubyRose
# license = <LICENSE OF THE CODE>
# description = A plugin to allow you to easily just have the commands be something findable
# source = https://codeberg.org/RubyRose/banager/src/branch/main/plugins/nixos.plugin.sh
grabs=("rg" "rga" "grep")
for grab in "${grabs[@]}"; do
    if command -v "$grab" &>/dev/null; then 
        alias grep='$grab'
        break 
    else 
        continue
    fi
done
dus=("dust" "du")
du_flags="-sh"
du_num=0
for dun in "${dus[@]}"; do 
    if command -v "$dun" &>/dev/null; then
        if [ "$du_num" = 0 ]; then
            dun="$dun $du_flags"
        fi
        alias du='$dun'
        break
    else 
        (( du_num += 1 )) 
    fi
done
fd=( "fd" "find" )
tags=("-tf -tl --show-errors --hidden --prune --exclude '.git node_modules'" "-L")
fd_num=0
for look in "${fd[@]}"; do 
    if command -v "$look" &>/dev/null; then 
        alias find='$look ${tags[$fd_num]}'
        break 
    else 
        (( fd_num += 1 ))
        continue
    fi
done
shows=("bat" "cat")
for show in "${shows[@]}"; do 
    if command -v "$show" &>/dev/null; then 
        alias cat='$show'
        break
    fi
done
ls_list=("eza" "ls")
ls_flags=("-Gumn --all --no-permissions --no-quotes --icons=always --group-directories-first" "-ChRskNp --all --time=access")
ls_num=0
for list in "${ls_list[@]}"; do
    if command -v "$list" &>/dev/null; then 
        alias ls='$list ${ls_flags[$ls_num]}'
        break
    else 
        (( ls_num += 1 ))
        continue
    fi
done

