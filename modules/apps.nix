let
 yabairc = builtins.readFile ../dotfiles/.yabairc;
in
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    git
    yabai
    skhd
  ];
  environment.variables.EDITOR = "nvim";
  environment.loginShell = "/etc/profiles/per-user/hest/bin/fish";
  
  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ../dotfiles/.skhdrc;
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    #extraConfig = yabairc;
  };

  services.tailscale = {
    enable = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    masApps = {
      # Keynote = 409183694;
      # Xcode = 497799835;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
    ];

    brews = [
      "curl"  # no not install curl via nixpkgs, it's not working well on macOS!
    ];

    casks = [
      "aldente"
      "insomnia"
      "docker"
      "visual-studio-code"
      "zoom"
      "microsoft-teams"
      "bitwarden"
      "iterm2"
      "slack"
      "jetbrains-toolbox"
      "tailscale"
      "mqttx"
      "openlens"
    ];
  };
}
