{
  description = "Nix for macOS configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: {
    darwinConfigurations.mbp = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix

        ./modules/host-users.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = inputs;
          home-manager.users.hest = import ./home;
        }
      ];
    };
    # nix code formater
    formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.alejandra;
  };
}
