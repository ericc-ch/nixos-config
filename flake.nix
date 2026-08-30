{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };

      mkMachine =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs-stable; };
          modules = [
            ./machines/shared.nix
            ./machines/${hostname}
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                (final: prev: {
                  # ly = pkgs-stable.ly;
                  mitmproxy = pkgs-stable.mitmproxy;
                  helium-browser = prev.callPackage ./pkgs/helium-browser { };
                  zen-browser = (prev.callPackage ./pkgs/zen-browser { }).default;
                  grok-bot = prev.callPackage ./pkgs/grok-bot { };
                })
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        hp240g5 = mkMachine "hp240g5";
        gl503ge = mkMachine "gl503ge";
      };
    };
}
