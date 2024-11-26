{pkgs, ...}: {
  home.packages = with pkgs; [
    
    ## CLI
    azure-cli
    jq
    diff-so-fancy
    bat
    eza
    wget
    git
    tree
    tldr
    glow
    kubectl
    jc
    dotnetPackages.Nuget
    unixtools.watch
    ## TUI
    btop
    gotop
    lf
    k9s
    zellij

    wezterm
    ## GUI
    kitty
    slack
    postman
    zoom-us
    discord
    vscode
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
      git = true;
      icons = "auto";
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    navi.enable = true;
    nushell.enable = true;
    ripgrep.enable = true;
    awscli.enable = true;
  };
}
