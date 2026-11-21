# username is supplied per machine by mkHome in flake.nix.
{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  # Records the release this config was first written for. Leave it alone when
  # upgrading nixpkgs and home-manager.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    tmux
    neovim
    git

    # Search tools used by Emacs (consult, projectile) and the shell.
    ripgrep
    fd

    # Nix formatter and language server, for editing this config with eglot.
    nixfmt
    nil
  ];

  # zsh is not managed by Home Manager, so nothing sources hm-session-vars.sh
  # and variables set here have no effect yet.
  home.sessionVariables = { };

  programs.home-manager.enable = true;

  # Emacs packages are installed by straight.el from ~/.config/emacs, so no
  # extraPackages here. Nix-provided packages land in site-lisp and shadow the
  # versions straight installs.
  programs.emacs.enable = true;

  # Per-project Nix shells. zsh needs this line in ~/.zshrc to activate it:
  #   eval "$(direnv hook zsh)"
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
