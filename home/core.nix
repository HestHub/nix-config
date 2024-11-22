{pkgs, ...}: {
  home.packages = with pkgs; [
    jq
    diff-so-fancy
    bat
    btop
    #dust
    eza
    gotop
    wget
    lf
    tree
    tldr
    glow
    kubectl
    k9s
    jc
    dotnetPackages.Nuget
    unixtools.watch
    slack
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
