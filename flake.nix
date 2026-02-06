{
  description = "Erickc's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        laptop1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./laptop1.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.erickc = import ./home.nix;
            }
          ];
        };

        laptop2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./laptop2.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.erickc = import ./home.nix;
            }
          ];
        };
      };
    };
}
