#!/usr/bin/env bash
# name = Replacement Commands 
# owner = RubyRose
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
for dun in "${dus[@]}"; do 
    if [ "$dun" = "${dus[1]}" ]; then 
        varls="du -sh"
    else 
        varls="dust"
    fi
    if command -v "$dun" &>/dev/null; then 
        alias duls='$varls'
    fi
done
fd=( "fd" "find" )
tags=("-tf -tl --show-errors --hidden --prune --exclude '.git node_modules'" "-L")
fd_num=0
for look in "${fd[@]}"; do 
    if command -v &>/dev/null; then 
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
    fi
done
ls_list=("eza" "ls")
flags=("-Gumn --all --no-permissions --no-quotes --icons=always --group-directories-first" "-ChRskNp --all --time=access")
ls_num=0
for list in "${ls_list[@]}"; do
    if command -v "$list" &>/dev/null; then 
        alias ls='$list ${flags[$ls_num]}'
    else 
        (( ls_num += 1 ))
    fi
done
