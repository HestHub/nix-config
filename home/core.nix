{pkgs, ...}: {
  home.packages = with pkgs; [
    jq
    diff-so-fancy
    bat
    eza
    gotop
    wget
    lf
    tree
    glow
    kubectl
    k9s
    jc
    dotnetPackages.Nuget
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    bat = {
      enable = true;
      config = {
        theme = "Nord";
        style = "numbers,changes,header";
      };
    };

    eza = {
      enable = true;
      enableAliases = false;
      git = true;
      icons = true;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    navi.enable = true;
    nushell.enable = true;
    ripgrep.enable = true;
    thefuck.enable = true;
    awscli.enable = true;
  };
}
