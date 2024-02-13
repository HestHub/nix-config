{
  config,
  lib,
  pkgs,
  ...
}: {
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;
    diff-so-fancy.enable = true;

    includes = [
      {
        condition = "gitdir:${builtins.getEnv "M_DIR"}";
        contents = {
          core.sshCommand = "ssh -i ~/.ssh/${builtins.getEnv "M_ID"}";
          user = {
            name = "${builtins.getEnv "M_USER"}";
            email = "${builtins.getEnv "M_MAIL"}";
          };
        };
      }
      {
        condition = "gitdir:${builtins.getEnv "C_DIR"}";
        contents = {
          core.sshCommand = "ssh -i ~/.ssh/${builtins.getEnv "C_ID"}";
          user = {
            name = "${builtins.getEnv "C_USER"}";
            email = "${builtins.getEnv "C_MAIL"}";
          };
        };
      }
      {
        condition = "gitdir:${builtins.getEnv "G_DIR"}";
        contents = {
          core.sshCommand = "ssh -i ~/.ssh/${builtins.getEnv "G_ID"}";
          user = {
            name = "${builtins.getEnv "G_USER"}";
            email = "${builtins.getEnv "G_MAIL"}";
          };
        };
      }
    ];

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    aliases = {
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
    ignores = [
      ".gradle/"
      ".idea/"
      "*.iml"
      ".classpath"
      "*.settings"
      ".project"
      ".gradle/"
      # IntelliJ IDEA
      "*.iml"
      ".idea/"
      ".flattened-pom.xml"
      "*.tgz"
      "*.lock"
      "!flake.lock"
      "bin/"
      "build/"
      "out/"
      ".rtx.toml"
      ".mise.toml"
      ".env"
    ];
  };
}
