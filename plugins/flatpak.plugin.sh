#!/usr/bin/env bash
#!banager/plugin
# name = Flatpak Plugin  
# version = 1.0.0
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = A flatpak that adds more functionality to your system.
# source = https://codeberg.org/RubyRose/blugins/raw/branch/main/plugins/flatpak.plugin.sh 
# shellcheck source=/dev/null
source -- /etc/os-release
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/declare.sh"
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/alias.sh"
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/package_manager.sh"
shopt -s nocasematch
if command -v flatpak &>/dev/null; then 
    if [ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh" ]; then 
        touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
        echo "Do you want your flatpaks installed on the [user] level, the [system] level, or ask every time [both]? "
        read -er flatpak_level
        # TODO: Make it so it allows an option for both
        case "$flatpak_level" in 
            user)
                level="--user"
                ;; 
            system) 
                level="--system"
                ;;
        esac
        # shellcheck disable=SC2154
        echo -e "$bash_declare\n$bash_gen\n$dont_delete\nlevel=$level" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
        # shellcheck disable=SC2154
        if [ ! -e "$flathub" ]; then
            case "$ID" in 
                "ubuntu") 
                    $SUPER "$PKG_MGR $INSTALL" -y gnome-software-plugin-flatpak 
                    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                    ;;
                "kubuntu") 
                    $SUPER "$PKG_MGR $INSTALL" -y kde-config-flatpak 
                    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                    ;;
                "debian")
                    if command -v plasma-shell &>/dev/null; then 
                        $SUPER "$PKG_MGR $INSTALL" plasma-discover-backend-flatpak 
                    fi
                    if command -v gnome-shell &>/dev/null; then
                        $SUPER "$PKG_MGR $INSTALL" gnome-software-plugin-flatpak 
                    fi
                    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                    ;;
                "chromeos" | "opensuse" | "endeavoros" | "nixos") flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo ;;
            esac
            echo -e ""
        fi
    fi
    # shellcheck disable=SC2154
    if [ ! -e "$flatseal" ]; then 
        if [ -e "${XDG_CONFIG_HOME:-$HOME/.config}/banager/plugins/archlinux.plugin.sh" ]; then
            if ! command -v flatseal &>/dev/null; then
                $SUPER "$PKG_MGR $INSTALL" --noconfirm flatseal
                echo -e "flatseal=true" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
            else 
                echo -e "flatseal=true" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
            fi
        else
            seal_run="flatpak run com.github.tchx84.Flatseal"
            if ! command "$seal_run" &>/dev/null; then 
                # shellcheck disable=SC2154
                flatpak "$fp_install" -y com.github.tchx84.Flatseal
                echo -e "flatseal=true" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
            else 
                echo -e "flatseal=true" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
            fi
        fi 
    fi
    # shellcheck disable=SC2154
    if [ ! -e "$flatsweep" ]; then 
        flatpak "$flat_install" io.github.giantpinkrobots.flatsweep
        echo "flatsweep=true" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/flatpak.info.sh"
    fi
    alias flatadd='flatpak install $level'
    alias flatrm='flatpak uninstall $level'
    alias flatudate='flatpak update $level -y'
    alias flatfix='flatpak repair'
    alias flatusb='flatpak create-usb'
fi 
