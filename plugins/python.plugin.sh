#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2034 source=/dev/null
#!banager/plugin
# name = Template 
# owner = RubyRose 
# license = CC BY-SA 4.0 International
# description = Makes python commands work for you
# version = 0.0.1
# source = https://codeberg.org/RubyRose/blugins/raw/branch/main/plugins/python.plugin.sh # This must be a raw link
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/src/declare.sh"
shopt -s nocasematch 
if command -v python &>/dev/null; then 
    echo "$XDG_CONFIG_HOME/banager/plugins/python.plugin.sh: python command installed" >> "$log_file"
    if command -v pipx &>/dev/null; then 
        alias pxadd='pipx install --include-deps'
        alias pxaddall='pipx install-all'
        alias pxrm='pipx uninstall --include-deps'
        alias pxup='pipx update'
        alias pxreadd='pipx reinstall --include-deps'
        alias pxpin='pipx pin'
        alias pxls='pipx list'
        eval "$(register-python-argcomplete pipx)"
    elif command -v uv &>/dev/null; then
        echo "$XDG_CONFIG_HOME/banager/plugins/python.plugin.sh: loading uv" >> "$log_file"
        echo "$XDG_CONFIG_HOME/banager/plugins/python.plugin.sh: uv command installed" >> "$log_file"
        # DOCUMENTATION: https://docs.astral.sh/uv/getting-started/features/
        if [ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/python.uv.autoupdate.sh" ]; then 
            touch "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/python.uv.autoupdate.sh"
            echo "Would you like to auto-update python? "
            read -rp "Would you like to auto-update python? [y/N] " pydate
            case "$pydate" in 
                *y* | *Y*) autodate=true ;;
                *n* | *N*) autodate=false ;;
            esac
            echo -e "$bash_declare\n$bash_gen\nauto_update=$autodate" >> "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/python.uv.autoupdate.sh"
        else
            echo "WIP"
        fi
        # TODO: Get auto-updating through uv
        source -- "${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/python.uv.autoupdate.sh"
        get_python_version=$(python --version &>/dev/null)
        python_version=${get_python_version##*python }
        echo "$python_version"
        case "$auto_update" in 
            "true")
                python_version_check=$(uv python list)
                next_version=$((python_version + 1 ))
                if [[ "$python_version" = *"$next_version"* ]]; then 
                    uv python install "$next_version"
                fi
                ;; 
        esac
        echo "$XDG_CONFIG_HOME/banager/plugins/python.plugin.sh: uv: auto_update is $auto_update" >> "$log_file"
        # Python aliases 
        alias upayd="uv python install"
        alias upyrm="uv python uninstall"
        alias upyn="uv python pin"
        alias uphynd="uv python find"
        # Pip aliases
        alias pip="uv pip"
        alias upad="uv pip install"
        alias uperm="uv pip uninstall"
        alias upihow="uv pip show"
        alias upeck="uv pip check"
        alias upist="uv pip list"
        alias upile="uv pip compile"
        echo "$XDG_CONFIG_HOME/banager/plugins/python.plugin.sh: loaded uv" >> "$log_file"
    fi
fi
