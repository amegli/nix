{
  description = "Shared Home Manager configuration, used from a private per-machine flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Only Emacs comes from here: nixos-26.05 has Emacs 30.2 and no 31.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    {
      # The configuration itself. It names no user, machine, or platform.
      homeModules.default = ./home.nix;

      # Builds a home configuration from the shared module, using the nixpkgs
      # and home-manager versions pinned in this repo's flake.lock. A private
      # flake calls this with the values for one machine.
      lib.mkHome =
        {
          system,
          username,
          # The release that was current when Home Manager was first set up on
          # the machine. It stays fixed for the life of that machine.
          stateVersion,
          homeDirectory ? null,
          extraModules ? [ ],
        }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          defaultHome = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
          };
          modules = [
            self.homeModules.default
            {
              home.username = username;
              home.homeDirectory = if homeDirectory != null then homeDirectory else defaultHome;
              home.stateVersion = stateVersion;
            }
          ]
          ++ extraModules;
        };

      # Starter private flake: nix flake init -t <this repo>
      templates.default = {
        path = ./templates/private;
        description = "Private per-machine flake that uses this configuration";
      };
    };
}
