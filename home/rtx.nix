
# wont install tools automaticly
# rtx activate fish | source
# rtx use --global go@1.21.4
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.rtx = {
    enable = true;
    settings = {
      tools = {
        go = "latest";
        java = "latest";
        # TODO dotnet core https://github.com/emersonsoares/asdf-dotnet-core
      };

      settings = {
        verbose = false;
        experimental = false;
      };
    };

  };
}
