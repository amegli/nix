# Shared Home Manager module. The username, home directory, and stateVersion
# are set per machine (see lib.mkHome in flake.nix), so none appear here.
{ lib, pkgs, ... }:

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

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.zsh = {
    enable = true;

    # Matches the oh-my-zsh defaults, including timestamps in the history file.
    history = {
      size = 50000;
      save = 10000;
      extended = true;
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };

    # Loaded last. For secrets and anything else that must stay out of the Nix
    # store and out of git.
    initContent = lib.mkAfter ''
      [[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
    '';
  };

  programs.home-manager.enable = true;

  # Emacs packages are installed by straight.el from ~/.config/emacs, so no
  # extraPackages here. Nix-provided packages land in site-lisp and shadow the
  # versions straight installs.
  programs.emacs.enable = true;

  # Per-project Nix shells. The zsh hook is added automatically because
  # programs.zsh is enabled.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
