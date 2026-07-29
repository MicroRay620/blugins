#!/usr/bin/env bash
# name = Gtrash Plugin 
# owner = RubyRose
# license = CC BY-SA 4.0 International
# source = https://codeberg.org/RubyRose/blugins/src/branch/main/plugins/gtrash.plugin.sh
# description = 
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
prune="${XDG_CACHE_HOME:-$HOME/.cache}/banager/user/prune.sh"
touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/gtrash.completion.sh" 
if command -v gtrash &>/dev/null; then 
    if [ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/gtrash.completion.sh" ]; then
        touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/gtrash.completion.sh" 
        gtrash completion bash >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/gtrash.completion.sh"
        source -- "${XDG_CACHE_HOME:-$HOME/.cache}/banager/gtrash.completion.sh"
    else 
        source -- "${XDG_CACHE_HOME:-$HOME/.cache}/banager/gtrash.completion.sh"
    fi
fi
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
    # shellcheck disable=SC2154
    echo -e "$bash_declare\n$bash_gen\n$dont_delete\npruning=\"$prune_denotion\"\nprune=$chosen_prune" >> "$prune"
fi
# shellcheck disable=SC1090
source "$prune"
if command -v &>/dev/null; then
    if [ -z "${XDG_DATA_HOME:-$HOME/.local/Trash}" ]; then
        # shellcheck disable=SC2154
        gtrash prune "$pruning $prune"
    fi
fi
alias rm="gtrash put"
