{
  description = "Home Manager configuration for this machine";

  # The shared configuration. To use a local clone instead, set this to a path
  # such as "git+file:///home/me/home-config".
  inputs.home-config.url = "github:amegli/nix";

  outputs =
    { home-config, ... }:
    {
      # Name the entry after your username so `home-manager switch` finds it
      # without arguments.
      homeConfigurations."me" = home-config.lib.mkHome {
        # One of: aarch64-darwin, x86_64-darwin, x86_64-linux, aarch64-linux
        system = "aarch64-darwin";
        username = "me";

        # The release current when you first set this machine up. Do not
        # change it later.
        stateVersion = "26.05";

        # Settings for this machine only, for example:
        #   extraModules = [ ({ pkgs, ... }: { home.packages = [ pkgs.htop ]; }) ];
      };
    };
}
