{...}: let
  username = "hest";
in {
  imports = [
    ./core.nix
    ./git.nix
    ./fish.nix
    ./k9s.nix
  ];
  home = {
    username = "${username}";
    homeDirectory = "/Users/${username}";

    stateVersion = "23.05";
  };
  # might be dangerous on macos ?
  xdg.enable = true;
  xdg.configHome = "/Users/${username}/.config";
  programs.home-manager.enable = true;
}
