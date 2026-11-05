{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Local-first dictation. Its nixpkgs must follow ours: a Hex built against
    # an older glibc finds no Vulkan adapter and its window never opens.
    hex = {
      url = "github:anomalyco/hex";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      hex,
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
                  helium-browser = prev.callPackage ./pkgs/helium-browser { };
                  google-chrome-dev = prev.callPackage ./pkgs/google-chrome-dev { };
                  zen-browser = (prev.callPackage ./pkgs/zen-browser { }).default;
                  grok-bot = prev.callPackage ./pkgs/grok-bot { };
                  zcode = prev.callPackage ./pkgs/zcode { };
                  chatgpt = prev.callPackage ./pkgs/chatgpt { };
                  opencode-desktop = prev.callPackage ./pkgs/opencode-desktop { };
                  t3code = prev.callPackage ./pkgs/t3code { };
                  # niri advertises the GNOME portal's GlobalShortcuts
                  # interface, but its backend is GNOME Shell, which is not
                  # running here, so every bind is rejected. Hex treats that
                  # rejection as fatal instead of falling back to `hex`
                  # commands, which leaves its listener off. Dropping the
                  # interface makes Hex take the commands path; bind them in
                  # niri (dotfiles/.config/niri/binds.kdl). Revisit when Hex
                  # falls back on its own or niri implements the portal.
                  xdg-desktop-portal-gnome =
                    prev.runCommand "xdg-desktop-portal-gnome-without-global-shortcuts" { }
                      ''
                        cp -r --no-preserve=mode ${prev.xdg-desktop-portal-gnome} $out
                        substituteInPlace $out/share/xdg-desktop-portal/portals/gnome.portal \
                          --replace-fail 'org.freedesktop.impl.portal.GlobalShortcuts;' ""
                      '';
                })
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit hex; };
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
