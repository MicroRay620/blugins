#!/usr/bin/env bash
#!banager/plugin
# name = NixOS Plugin 
# owner = RubyRose
# license = <LICENSE OF THE CODE>
# source = https://codeberg.org/RubyRose/banager/raw/branch/main/plugins/nixos.plugin.sh
# shellcheck disable=SC2154,SC2153 source=/dev/null
source -- "$XDG_DATA_HOME/banager/commands/declare.sh"
source -- "$XDG_CONFIG_HOME/banager/config"
nix_user="${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/nixos.storage.sh"
if command -v nix &>/dev/null; then 
    echo "$XDG_CONFIG_HOME/banager/plugins/nixos.plugin.sh: nix command installed" >> "$log_file"
    if [ ! -e "$nix_user" ]; then 
        echo "$XDG_CONFIG_HOME/banager/plugins/nixos.plugin.sh: $nix_user not found: creating $nix_user" >> "$log_file"
        touch "$nix_user"
        # INFO: make sure to have the function, call, and/or file that needs the variable (plus line #) after the variable is used
        echo "Nix Path [can use environment variables] (default: /etc/nixos/): "
        read -r nix_path 
        case "$nix_path" in 
            "default" | "Default" | "") 
                # We have this to set a default path for users
                nix_path="/etc/nixos" 
                ;;
        esac
        read -rp "What's your host name? " host_name
        echo -e "$bash_declare\n$bash_gen\n$dont_delete\nexport NIX_PATH=$nix_path\nexport HOST=$host_name" >> "$nix_user"
        echo "$XDG_CONFIG_HOME/banager/plugins/nixos.plugin.sh: $nix_user not found: created $nix_user" >> "$log_file"
    else 
        echo "$XDG_CONFIG_HOME/banager/plugins/nixos.plugin.sh: $nix_user found" >> "$log_file"
    fi
    echo "$XDG_CONFIG_HOME/banager/plugins/nixos.plugin.sh: loading $nix_user" >> "$log"
    echo "$XDG_CONFIG_HOME/banager/plugins/nixos.plugin.sh: loaded $nix_user" >> "$log"
    source -- "$nix_user"
    if [ -e "$NIX_PATH/nix-ld.nix" ]; then
        use_nixld() {
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"
            export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$NIX_LD_LIBRARY_PATH/pkgconfig"
        }
    fi
    alias nixos-rebuild='cd $NIX_PATH && $SUPER nixos-rebuild'
    alias nixbuild='nixos-rebuild switch --flake .#$HOST'
    alias nix-store='$SUPER nix-store'
    alias nix-collect-garbage='$SUPER nix-collect-garbage'
    alias nix-add='cd $HOME/nixos && $EDITOR'
fi
