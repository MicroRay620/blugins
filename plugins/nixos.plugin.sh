#!/usr/bin/env bash
#!banager/plugin
# name = NixOS Plugin 
# owner = RubyRose
# license = <LICENSE OF THE CODE>
# source = https://codeberg.org/RubyRose/banager/src/branch/main/plugins/nixos.plugin.sh
# shellcheck source=/dev/null
source -- "$XDG_DATA_HOME/banager/commands/declare.sh"
source -- "$XDG_CONFIG_HOME/banager/config.sh"
nix_user="${XDG_CACHE_HOME:-$HOME/.cache}/banager/plugins/nixos.storage.sh"
if command -v nix &>/dev/null; then 
    if [ ! -e "$nix_user" ]; then 
        touch "$XDG_CONFIG_HOME/banager/user/nixos.sh"
        # INFO: make sure to have the function, call, and/or file that needs the variable (plus line #) after the variable is used
        echo "Nix Path [can use environment variables] (default: /etc/nixos/): "
        read -r nix_path 
        case "$nix_path" in 
            "default" | "Default" | "") 
                # We have this to set a default path for users
                nix_path="/etc/nixos" 
                ;;
        esac
        # shellcheck disable=SC2154
        echo -e "$bash_declare\n$bash_gen\n$dont_delete\nexport NIX_PATH=$nix_path" >> "$nix_user"
    fi
    if [ -e "$nix_path/nix-ld.nix" ]; then
        use_nixld() {
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"
            export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$NIX_LD_LIBRARY_PATH/pkgconfig"
        }
    fi
    # THE ALIAS VARIABLE MAY BE REMOVED
    # shellcheck disable=SC2154
    if [ "$distro_alias" = "true" ]; then 
        # shellcheck disable=SC2153
        alias nixos-rebuild='cd $NIX_PATH && $SUPER nixos-rebuild'
        alias nixbuild='nixos-rebuild switch --flake .#nixos'
        alias nix-store='$SUPER nix-store'
        alias nix-collect-garbage='$SUPER nix-collect-garbage'
        alias nix-add='cd $HOME/nixos && $EDITOR'
    fi
    # shellcheck source=/dev/null
    source "$nix_user"
fi
