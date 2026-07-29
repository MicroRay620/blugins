#!/usr/bin/env bash
#!banager/plugin
# name = Brew Alias Plugin  
# owner = RubyRose
# license = CC BY-SA 4.0 International
# description = A plugin that just adds custom aliases for the Homebrew package manager
# source = https://codeberg.org/RubyRose/blugins/src/branch/main/plugins/brew.plugin.sh 
# shellcheck source=/dev/null
source -- /etc/os-release
source -- "${XDG_DATA_HOME:-$HOME/.local/share}/banager/src/declare.sh"
shopt -s nocasematch 
if command -v brew &>/dev/null; then
    if [ -e "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else 
        echo "Something is wrong with homebrew: /home/linuxbrew/.linuxbrew/bin/brew doesn't exist"
    fi
    alias brewadd="brew install"
    alias brewrm="brew remove"
    alias brewudate="brew update"
else
    echo "Do you want brew installed?"
    read -r brew_opt
    case "$brew_opt" in 
        *yes*)
            echo "Installing homebrew..."
            if [ -e "${XDG_CONFIG_HOME:-$HOME/.config}/banager/plugins/archlinux.plugin.sh" ]; then 
                $AUR "$INSTALL" --noconfirm brew-git
            else 
                case "$ID" in 
                    "nixos") 
                        echo -e "Look at either:
                        \n- https://github.com/zhaofengli/nix-homebrew
                        \nor
                        \nhttps://mynixos.com/options/homebrew" 
                        ;;
                    *)
                        case "$ID_LIKE" in 
                            "nixos")
                                echo -e "Look at either:
                                \n- https://github.com/zhaofengli/nix-homebrew
                                \nor
                                \nhttps://mynixos.com/options/homebrew" 
                                ;;
                            *) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ;; 
                        esac
                        ;;      
                esac
            fi
            echo "Installed homebrew :)"
            echo "Restart your shell"
            ;;
        *) echo "Why do you have this plugin installed then?" ;;
    esac

fi
