{
  description = "Erickc's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
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
      nixpkgs-stable,
      home-manager,
      zen-browser,
      ...
    }@inputs:
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
            ./hosts/${hostname}.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.llm-agents.overlays.default
                (final: prev: {
                  zen-browser = inputs.zen-browser.packages.${prev.stdenv.hostPlatform.system}.default;
                  ly = pkgs-stable.ly;
                })
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.erickc = import ./home/${hostname}.nix;
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
