#!/usr/bin/env bash
# name = Gtrash Plugin 
# owner = RubyRose
# source = https://codeberg.org/RubyRose/banager/src/branch/main/plugins/gtrash.plugin.sh
source -- "$XDG_DATA_HOME/banager/commands/declare.sh"
prune="$XDG_CONFIG_HOME/banager/user/prune.sh"
if [ ! -e "$prune" ]; then
    touch "$prune"
    echo "Would you like to prune in days or size? "
    read -r prune_choice
    case "$prune_choice" in
        *ay* | *AY*)
            days_choice=""
            prune_denotion="--day"
            while true; do 
                echo "How many days? "
                read -r days_choice
                if [[ "$days_choice" =~ ^[0-9]+$ ]]; then 
                    chosen_prune="$days_choice"
                    break 
                else 
                    echo "That isn't a number, please try again"
                fi
            done 
            ;;
        *ize* | *IZE*)
            while true; do 
                prune_denotion="--size"
                echo "Size amount? "
                read -r size_choice
                if [[ "$size_choice" =~ ^[0-9]+$ ]]; then 
                    break 
                else 
                    echo "Not a valid size, try again"
                fi
            done 
            echo "Byte size? (In all caps and using the acronym, example: GB) "
            read -r byte_choice
            chosen_prune="$size_choice$byte_choice"
    esac
    echo -e "$bash_declare\n$bash_gen\n$dont_delete\npruning=\"$prune_denotion\"\nprune=$chosen_prune" >> "$prune"
fi
# shellcheck disable=SC1090
source "$prune"
if command -v &>/dev/null; then
    if [ -z "${XDG_DATA_HOME:-$HOME/.local/Trash}" ]; then
        gtrash prune "$pruning $prune"
    fi
fi
