#!/usr/bin/env bash
#!banager/plugin
# name = System Update Plugin
# version = 1.0.0
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = A System Update plugin that will automatically update your system 
# source = https://codeberg.org/RubyRose/blugins/raw/branch/main/plugins/nixos.plugin.sh
# shellcheck source=/dev/null
source -- /etc/os-release
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/declare.sh"
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/alias.sh"
app_yes=0
app_non=0
for appimage in am appman; do 
    if [ "$app_non" -ge 1 ]; then 
        image=false
        break
    else 
        image=true
    fi
    if command -v "$appimage" &>/dev/null; then 
        app_succ="$appimage"
        (( app_yes += 1 ))
    else
        (( app_non += 1 ))
    fi
done
if [ "$image" = "true" ]; then 
    if [ "$app_yes" = 0 ]; then 
         am="$app_succ"
     elif [ "$app_yes" = 1 ]; then 
        am="am -u --apps && appman -u --apps"
    else 
        am="am and/or appman is not installed"
    fi
fi
if command -v flatpak &>/dev/null; then 
    flatpak="flatpak update -y"
else 
    flatpak="Flatpak not installed"
fi
# shellcheck disable=SC2154
case "$ID" in 
    "archlinux") alias sysupdate='$backup && $AUR && $flatpak && $am' ;;
    "nixos") alias sysupdate='$backup && $flatpak && $am' ;;
    *)
        case "$ID_LIKE" in 
            "archlinux") alias sysupdate='$backup && $AUR && $flatpak && $am' ;;
            "nixos") alias sysupdate='$backup && $AUR && $flatpak && $am' ;;
            *) alias sysupdate='$backup && $SUPER $PKG_MGR $UPDATE && $flatpak && $am'
        esac
        ;;
esac

SysUpdate() {
    # Source - https://stackoverflow.com/a/39959192
    # Posted by Filippo Lauria, modified by community. See post 'Timeline' for change history
    # Retrieved 2026-06-15, License - CC BY-SA 4.0
    update_file="${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/update.info.sh"
    if [ ! "$ID" = "nixos" ] || [ ! "$ID_LIKE" = "nixos" ]; then 
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
            echo "How often would you want your updates? [yoe in a whole number] "
            read -r update_number

            echo "update_frequency=$update_number" >> "$update_file"
            echo "$update_frequency"
        fi
        if [ -z "$updates_missed" ]; then 
            echo "updates_missed=0" >> "$update_file"
            updates_missed=0 
        fi
        if [ -z "$update_choice" ]; then
            # shellcheck disable=SC2004
            if (( $days%$update_frequency == 0 )) || [ "$updates_missed" -gt 0 ]; then
                echo -e "IT'S SYSTEM UPDATE DAY!!!\nWould you like to update? [y/N]"
                read -r update_option
                case $update_option in
                    "y" | "Y" | "yes" | "Yes" | "YES")
                        # shellcheck disable=SC2086
                        updates_missed=0
                        $backup
                        case "$PKG_MGR" in 
                            pacman) sysupdate ;;
                            *) $SUPER "$PKG_MGR $UPDATE" ;;
                        esac
                        flatpak update -y
                        if [ "$app_yes" -ge 1 ]; then
                            am -u
                            appman -u 
                        else
                            $app_succ -u
                        fi
                        update_option="no"
                        ;;
                    "n" | "N" | "no" | "No" | "NO")
                        echo "Alright... No update I guess :("
                        update_option="no"
                        (( updates_missed += 1 ))
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

