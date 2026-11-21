# home-config

A Home Manager configuration that names no user or machine. Each machine has a
small private flake that supplies its username and platform and imports this
one.

## Contents

- `home.nix`: the configuration (packages, Emacs, direnv).
- `flake.nix`: exports `homeModules.default` (the module), `lib.mkHome` (builds
  a home configuration from it), and a template for the private flake.
- `flake.lock`: pins nixpkgs and home-manager. Every machine that uses this
  repo gets these versions.

## Set up a machine

Nix must be installed with flakes enabled.

```
mkdir -p ~/.config/home-manager && cd ~/.config/home-manager
nix flake init -t github:amegli/nix
```

Edit the new `flake.nix`: set `system` and `username` (in both places). Then:

```
git init && git add flake.nix
nix run home-manager/release-26.05 -- switch --flake ~/.config/home-manager
git add flake.lock
```

Later switches are `home-manager switch --flake ~/.config/home-manager`.

## Change the shared configuration

1. Edit, commit, and push in this repo.
2. In the private flake: `nix flake update home-config`.
3. `home-manager switch --flake ~/.config/home-manager`.

To try uncommitted changes without touching the private lock file:

```
home-manager switch --flake ~/.config/home-manager --override-input home-config path:$HOME/Development/home-config
```

## Update package versions

Run `nix flake update` in this repo, commit and push `flake.lock`, then follow
steps 2 and 3 above.

## Use the module without mkHome

`lib.mkHome` uses this repo's pinned nixpkgs and home-manager. To use your own,
import `homeModules.default` into your own `homeManagerConfiguration` and set
`home.username`, `home.homeDirectory`, and `home.stateVersion` yourself.
