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
        java = ["openjdk-17" "openjdk-21","zulu-21"];
        nodejs = ["lts" "16"];
        dotnet = ["7" "8"];
      };

      settings = {
        verbose = false;
        experimental = false;
      };
    };
  };
}
