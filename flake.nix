{
  description = "Erickc's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        hp240g5 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hp240g5.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.llm-agents.overlays.default
                (final: prev: {
                  zen-browser = inputs.zen-browser.packages.${prev.stdenv.hostPlatform.system}.default;
                })
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.erickc = import ./home.nix;
            }
          ];
        };
      };
    };
}
