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
    # kanata
    kubectl
    jc
    dotnetPackages.Nuget
    unixtools.watch
    tinygo
    wasmtime
    docker
    colima
    docker-credential-helpers
    kubelogin
    cbonsai
    fzf
    gping
    watchexec
    ## TUI
    btop
    gotop
    lf
    k9s
    zellij
    lazydocker
    fx
    jqp
    diskonaut

    wezterm
    ## GUI
    kitty
    # ghostty
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

    zoxide = {
      enable = true;
    };

    navi.enable = true;
    nushell.enable = true;
    ripgrep.enable = true;
    awscli.enable = true;
  };
}
