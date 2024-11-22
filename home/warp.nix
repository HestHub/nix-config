{ config, lib, pkgs, dots, ... }:

let
  themePath = "${dots}/warp/nord.yaml";
in
{
  home.file.".warp/themes/nord.yaml".source = 
    config.lib.file.mkOutOfStoreSymlink ../dotfiles/warp/nord.yaml;

  home.activation.linkWarpTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -sf ${themePath} ${config.home.homeDirectory}/.warp/themes
  '';
}

# Solution that symlinks to a file in /nix/store
# possible more proper way to do it
#
#{ config, lib, pkgs, ... }:
#
#let
#  warpThemePath = "/Users/hest/dev/me/nix-config/dotfiles/warp/nord.yaml";
#in
#
#
#{
#  home.file.".warp/themes/nord.yaml".source = 
#    config.lib.file.mkOutOfStoreSymlink ../dotfiles/warp/nord.yaml;
#
#}