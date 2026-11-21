# Shared Home Manager module. The username, home directory, and stateVersion
# are set per machine (see lib.mkHome in flake.nix), so none appear here.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
    neovim
    git

    # Search tools used by Emacs (consult, projectile) and the shell.
    ripgrep
    fd

    # Nix formatter and language server, for editing Nix files with eglot.
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
