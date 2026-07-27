#!/usr/bin/env bash
#!banager/plugin
# name = System Update Plugin
# owner = RubyRose
# source = https://codeberg.org/RubyRose/blugins/src/branch/main/plugins/nixos.plugin.sh
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
source -- "$XDG_DATA_HOME/banager/src/alias.sh"
SysUpdate() {
    # Source - https://stackoverflow.com/a/39959192
    # Posted by Filippo Lauria, modified by community. See post 'Timeline' for change history
    # Retrieved 2026-06-15, License - CC BY-SA 4.0
    #echo "$os"
    update_file="$XDG_CONFIG_HOME/banager/user_configs/update.sh"
    if ! command -v nix &>/dev/null ; then
        if [ ! -e "$update_file" ]; then
            touch "$update_file"
            # shellcheck disable=SC2154
            echo -e "$bash_declare\n$bash_gen\n$dont_delete the SysUpdate() function in the .bashrc file" >> "$update_file"
        fi

        # shellcheck disable=SC1090
        source "$update_file"

        # TODO: figure out how to have a bash file input code into another file
        # INFO: This may have a seperate file or just have update.sh be pregenerated with the config
        seconds=$(date -d "@$(($(date +%s) - $(stat / --format %W)))" +%s)
        days=$(($(date -d @"$seconds" +%d)))

        if [ -z "$update_frequency" ]; then
            # This is here for you
            echo "How often would you want your updates? [ype in a whole number] "
            read -r update_number

            echo "export update_frequency=$update_number" >> "$update_file"
            echo "$update_frequency"
        fi

        if [ -z "$update_choice" ]; then
            # shellcheck disable=SC2004
            if (( $days%$update_frequency == 0 )); then
                echo -e "IT'S SYSTEM UPDATE DAY!!!\nWould you like to update? [y/N]"
                read -r update_option
                case $update_option in
                    "y" | "Y" | "yes" | "Yes" | "YES")
                        # shellcheck disable=SC2086
                        case "$PKG_MGR" in 
                            pacman)
                                case "$AUR" in 
                                    paru) paru ;;
                                    yay) yay ;;
                                    pacman) $SUPER "$PKG_MGR" -Syu ;;
                                esac
                                ;;
                            *) $SUPER "$PKG_MGR $UPDATE" ;;
                        esac
                        flatpak update -y
                        am -u
                        update_option="no"
                        ;;
                    "n" | "N" | "no" | "No" | "NO")
                        echo "Alright... No update I guess :("
                        update_option="no"
                        ;;
                esac
                echo "export update_choice=$update_option" >> "$XDG_CONFIG_HOME"/banager/user_configs/update.sh
                sleep 2
                clear # WARNING: this may be removed
            fi
        fi
    fi
}
SysUpdate
if [[ "$PKG_MGR" = "pacman" ]]; then
    alias sysupdate='$backup && $AUR && flatpak update -y && $am'
elif [[ "$PKG_MGR" = "nix" ]]; then
    alias sysupdate='$backup && flatpak update -y && $am'
else
    alias sysupdate='$backup && $SUPER $PKG_MGR $UPDATE && flatpak $UPDATE && $am'
fi

