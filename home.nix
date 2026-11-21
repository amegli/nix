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

    gh

    # Used by the Emacs config: markdown-command, the default face (Hack Nerd
    # Font Mono), and the icon glyphs for nerd-icons.
    pandoc
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;

    # Grey suggestion from history while typing; right arrow accepts it.
    autosuggestion.enable = true;
    # Colors the command line while typing; unknown commands show in red.
    syntaxHighlighting.enable = true;

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

  # Fuzzy finder. Ctrl-R searches history, Ctrl-T inserts a file path, and
  # Alt-C changes directory. fd lists the candidates so .gitignore is honored.
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
  };

  # `z <part of a directory name>` jumps to a previously visited directory.
  programs.zoxide.enable = true;

  # Prompt. Replaces the oh-my-zsh theme, which stays set as the fallback.
  programs.starship.enable = true;

  programs.home-manager.enable = true;

  # Emacs packages are installed by straight.el from ~/.config/emacs. Packages
  # listed here land in site-lisp and shadow the versions straight installs, so
  # keep this to packages with a compiled module. vterm is here because its
  # module otherwise needs cmake and GNU libtool at first launch; the Emacs
  # config loads it with `:straight nil`.
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  # Per-project Nix shells. The zsh hook is added automatically because
  # programs.zsh is enabled.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
