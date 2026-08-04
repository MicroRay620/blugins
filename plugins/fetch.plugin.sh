#!/usr/bin/env bash
# name = Fastfetch Plugin 
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = A system information plugin that adds allows for some unique options with your preferred fetch
# source = https://codeberg.org/RubyRose/banager/src/branch/main/plugins/fetch.plugin.sh
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
source -- "${XDG_CONFIG_HOME:-$HOME/.config}/banager/config.sh"
# All of these may become their own file, idk yet
# System Info Checks
# RandomFlags
RandomFlags() {
    # This will randomly give you a hyfetch flag
    local rand 
    rand=$(date +%s)
    flags=(transgender transfeminine lesbian sapphic finsexual femboy gendernonconforming2 plural femme)
    use_flag="${flags[$(( rand % ${#flags[@]} ))]}"
    hyfetch -b fastfetch -p "$use_flag"
    # echo "$use_flag" # INFO: this is here for debugging what pride flag is used
}
Troll() {
    fetch_file="$XDG_CONFIG_HOME/banager/user/fetch.sh"
    if [[ ! -e "$fetch_file" ]]; then 
        touch "$fetch_file"
        # shellcheck disable=SC2154
        echo -e "$bash_declare\n$bash_gen\n$dont_delete this file is needed for the Flag() function in the .bashrc file\n# This file is here to help check what fastfetch to use" >> "$fetch_file"
    fi
    # shellcheck disable=SC1090
    source "$fetch_file"
}
Flag() {
    fetch_file="$XDG_CONFIG_HOME/banager/user/fetch.sh"
    # This will load the troll function
    Troll 
    # shellcheck disable=SC1090
    source "$fetch_file"
    
    if [[ -z "$fetch" ]]; then
        echo "test [in -e '$fetch']"
        echo "Pick a fetch option? [random] [hyfetch] [fastfetch]"
        read -r flag 
        case $flag in 
            "fastfetch" | "fast" | "ff" | "Fastfetch" | "FF" ) 
                echo "Do you want small logo? [y/N]"
                read -r choice
                case $choice in 
                    "y" | "Y") echo "fetch=fastfetch-small" >> "$fetch_file"
                esac
                ;;
            "hyfetch" | "Hyfetch" | "Hy" | "hf" | "HF") echo "fetch=hyfetch" >> "$fetch_file" ;;
            "random" | "Random") echo "fetch=random" >> "$fetch_file" ;;
            "troll" | "Troll") 
                echo "fetch=troll" >> "$fetch_file" 
                # Gonna have this even change the host name 
                echo "What distro would you like to display? "
                read -r troll_logo
                echo "troll=$troll_logo" >> "$fetch_file"
                
                echo "What backend would you like? [hyfetch] [fastfetch] "
                read -r backend
                echo "backend=$backend" >> "$fetch_file"
                fetch_backend=("-l" "--distro")
                ;;
        esac
    fi
    if [[ "$fetch" = "fastfetch-small" ]]; then
        fastfetch -l small
        export display_fetch="fastfetch -l small"
    else
        case $fetch in 
            "fastfetch") 
                fastfetch 
                export display_fetch="fastfetch"
                alias smallfetch='fastfetch -l small'
                ;;
            "hyfetch") 
                hyfetch 
                export display_fetch="hyfetch"
                alias hydistro='hyfetch --distro='
                ;;
            "random") 
                RandomFlags
                export display_fetch="RandomFlags"
                alias hydistro='hyfetch --distro='
                ;;
            "troll") 
                if [[ "$backend" = "fastfetch" ]]; then 
                    backendDistro="${fetch_backend[0]}"
                else
                    backendDistro="${fetch_backend[1]}"
                fi
                # shellcheck disable=SC2154
                export display_fetch="$fetch $backendDistro=$troll"
                ;;
        esac
    fi
}
alias clear='clear && $display_fetch'
Flag

