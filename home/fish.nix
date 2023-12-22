{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
          set fish_greeting # Disable greeting
          abbr -a -- .. "cd .."
          abbr -a -- ... "cd ../.."
          abbr -a -- .... "cd ../../.."
          abbr -a -- ..... "cd ../../../.."
          abbr -a -- - "cd -"
        '';
    shellAbbrs = {
      k = "kubectl";
      g = "git";
      cat = "bat";
      ltree = "eza -FThl --git";
      vi = "nvim";
      vim = "nvim";
    };

    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
      
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    plugins = [
      # TODO add plugin https://github.com/Gazorby/fish-abbreviation-tips
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
  };
}
