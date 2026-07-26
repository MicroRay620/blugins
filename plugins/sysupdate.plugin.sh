#!/usr/bin/env bash
#!banager/plugin
# name = System Update Plugin
# owner = RubyRose
# source = https://codeberg.org/RubyRose/banager/src/branch/main/plugins/nixos.plugin.sh
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/commands/declare.sh"
source -- "$XDG_DATA_HOME/banager/commands/alias.sh"
SysUpdate() {
    # Source - https://stackoverflow.com/a/39959192
    # Posted by Filippo Lauria, modified by community. See post 'Timeline' for change history
    # Retrieved 2026-06-15, License - CC BY-SA 4.0
    #echo "$os"
    update_file="$XDG_CONFIG_HOME/banager/user_configs/update.sh"
    if ! command -v nix &>/dev/null ; then
        if [ ! -e "$update_file" ]; then
            touch "$update_file"
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
                echo -e "IT'S SYSTEM UPDATE DAY!!!\nWould you like to update? [/N]"
                read -r update_option
                case $update_option in
                    "y" | "Y" | "yes" | "Yes" | "YES")
                        if [ "$PKG_MGR" = "pacman" ]; then
                            if [ "$AUR" = "paru" ]; then
                                paru
                            elif [ "$AUR" = "yay" ]; then
                                yay
                            fi
                            flatpak update -y
                            am -u
                        else
                            # shellcheck disable=SC2086
                            $SUPER $PKG_MGR $UPDATE
                            flatpak update -y
                            am -u
                        fi
                        update_option="no"
                        ;;
                    "n" | "N" | "no" | "No" | "NO")
                        echo "Alright. Skipping update :("
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
if [[ "$PKG_MGR" = "pacman" ]]; then
    alias sysupdate='$backup && $AUR && flatpak update -y && $am'
elif [[ "$PKG_MGR" = "nix" ]]; then
    alias sysupdate='$backup && flatpake update -y && $am'
else
    alias sysupdate='$backup && $SUPER $PKG_MGR $UPDATE && flatpak $UPDATE && $am'
fi

