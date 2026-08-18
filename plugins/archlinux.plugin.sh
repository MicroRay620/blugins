#!/usr/bin/env bash
#!banager/plugin
# name = Arch Linux Plugin 
# version = 1.0.1
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = This is a plugin to enable commands for the AUR and arch specific things
# source = https://codeberg.org/RubyRose/banager/raw/branch/main/plugins/archlinux.plugin.sh
# shellcheck disable=SC2154 source=/dev/null
source -- "$XDG_DATA_HOME/banager/commands/package_managers.sh"
source -- "$XDG_DATA_HOME/banager/commands/declare.sh"
source -- "$XDG_DATA_HOME/banager/commands/alias.sh"
source -- "$XDG_CONFIG_HOME/banager/config"
if [ -e "$XDG_CACHE_HOME/banager/aur.command.sh" ]; then 
    source -- "$XDG_CACHE_HOME/banager/plugins/aur.command.sh"
else
    touch "$XDG_CACHE_HOME/banager/aur.command.sh"
    source -- "$XDG_CACHE_HOME/banager/aur.command.sh"
fi
if [ "$PKG_MGR" = "${managers[3]}" ]; then
    if [ -z "$cache_aur" ] || [ ! "$cache_aur" = "chaotic" ]; then
        if command -v yay &>/dev/null; then 
            AUR=yay 
        elif command -v paru &>/dev/null;then 
            AUR=paru
        else 
            echo -e "\e[31mERROR: No AUR manager found. \n Cause: BC1: paru or yay does not exist on the system"
            echo -e "Would you like [paru] or [yay]? (Defaults to paru) [type chaotic to skip] "
            read -er aur_choice 
            case "$aur_choice" in 
                *yay* | *Yay* | *YAY*) aur_choice="yay" ;;
                *paru* | *Paru* | *PARU*) aur_choice="paru" ;;
                *chaotic* | *) aur_choice="pacman" ;;
            esac
        fi
        if [ ! "$aur_choice" = "pacman" ]; then
            $SUPER "${managers[3]}" -S --needed base-devel 
            git clone "https://aur.archlinux.org/${aur_choice}.git"
            cd "$aur_choice" || exit 1
            makepkg -si
        fi
        AUR="$aur_choice"
        cached_aur="$aur_choice"
        echo -e "$bash_declare\n$bash_gen\ncached_aur=$cached_aur" >> "$XDG_CACHE_HOME/banager/aur.command.sh"
    fi
    if [ "$cached_aur" = "chaotic" ]; then
        chaotic=$(grep "Include = /etc/pacman.d/chaotic-mirrorlist" /etc/pacman.conf)
        if [ -z "$chaotic" ]; then 
            $SUPER pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
            $SUPER pacman-key --lsign-key 3056513887B78AEB
            $SUPER "$PKG_MGR" -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
            $SUPER "$PKG_MGR" -Syu
        fi
        AUR="$SUPER pacman"
    else 
        AUR="$SUPER pacman"
    fi
    echo "${XDG_CONFIG_HOME:-$HOME/.config}/banager/plugins/archlinux.plugin.sh: Cached AUR is $cached_aur"
    if command -v ble &>/dev/null; then 
        $AUR blesh
    fi
    alias extpacadd='$SUPER $PKG_MGR -U'
    alias auradd='$AUR $INSTALL'
    alias aurrm='$AUR $REMOVE'
    alias aurudate='$AUR $UPDATE'
    if command -v downgrade &>/dev/null; then 
        alias downgrade='$SUPER downgrade'
    fi
fi
