{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fish
    fzf
    grc
    fishPlugins.autopair
    fishPlugins.colored-man-pages
    fishPlugins.done
    fishPlugins.fzf
    fishPlugins.grc
    fishPlugins.sponge
    fishPlugins.z
  ];

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
      vi = "nvim";
      vim = "nvim";
      ls = "eza -1 -F --group-directories-first";
      lsa = "eza -1 -F --group-directories-first -a";
      ll = "eza -1 -F --group-directories-first -l --git";
      lla = "eza -1 -F --group-directories-first -l -a --git";
      lt = "eza -1 -F -T";
    };

    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };

      update_git = ''
        set back (pwd)
        for d in (find . -type d -name .git)
          cd "$d/.."
          pwd
          git pull
          cd $back
        end
      '';
      

      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
  };
}
