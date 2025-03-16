{pkgs, ...}: {
  home.packages = with pkgs; [
    ## CLI
    jq
    wget
    git
    tre-command
    tldr
    gh
    # kanata
    kubectl
    dotnetPackages.Nuget
    unixtools.watch
    tinygo
    wasmtime
    docker
    colima
    docker-credential-helpers
    kubelogin
    fzf
    watchexec
    cargo-nextest
    ## TUI
    gotop
    lf
    k9s
    zellij
    lazydocker

    ## GUI
    slack
    postman
    zoom-us
    discord
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

    zoxide = {
      enable = true;
    };

    navi.enable = true;
    nushell.enable = true;
    ripgrep.enable = true;
    awscli.enable = true;
  };
}
