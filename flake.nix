{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # Builds one home configuration. home.nix is shared by every machine;
      # per-machine modules can be appended through extraModules.
      mkHome =
        {
          system,
          username,
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit username; };
          modules = [ ./home.nix ] ++ extraModules;
        };
    in
    {
      # One entry per machine, named "user@hostname". `home-manager switch
      # --flake .` picks the entry that matches the machine it runs on. Use the
      # short hostname in lowercase: home-manager looks it up with GNU
      # `hostname -s`, which lowercases the name on macOS.
      homeConfigurations = {
        "andrewmegli@andrews-macbook-pro" = mkHome {
          system = "aarch64-darwin";
          username = "andrewmegli";
        };
      };
    };
}
