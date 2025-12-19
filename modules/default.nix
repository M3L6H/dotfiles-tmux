{
  pname,
  ...
}@flake-args:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.m3l6h.${pname} = {
    enable = mkEnableOption "m3l6h's custom tmux configuration";
    impermanence.enable = mkEnableOption "persistence for key files & directories";
  };

  imports = [
    (import ./fingers.nix flake-args)
    (import ./line-numbers.nix flake-args)
    (import ./sessionx.nix flake-args)
    (import ./tmuxinator.nix flake-args)
  ];

  config =
    let
      cfg = config.m3l6h.${pname};

      # integration with my custom zsh
      zsh =
        config.m3l6h.zsh or {
          enable = false;
        };
    in
    mkIf cfg.enable {
      home.packages = with pkgs; [
        wl-clipboard # Used by yank plugin
      ];

      programs.tmux = {
        enable = true;
        baseIndex = 1;

        extraConfig = ''
          # Shift-Alt- vim keys to switch windows
          bind -n M-H previous-window
          bind -n M-L next-window

          # Reload tmux with PREFIX+r
          bind r source-file ~/.config/tmux/tmux.conf

          # Disable confirmation for closing pane
          bind x kill-pane

          # Close all panes except current
          bind X confirm-before -p "close all panes except current? (y/n)" 'kill-pane -a'

          # Kill session
          bind Q confirm-before -p "kill-session #S? (y/n)" kill-session

          # Quick window jumping
          bind f select-window -t 1
          bind d select-window -t 2
          bind s select-window -t 3
          bind a select-window -t 4

          # Proper vim select
          bind-key -T copy-mode-vi 'v' send -X begin-selection
          bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle

          # Open panes in current directory
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"

          # Unbind time
          unbind t

          # Increase scrollback buffer size
          set-option -g history-limit 100000

          # Disable detatch on destroy so we can easily close all tmux sessions
          set-option -g detach-on-destroy off

          # No auto renaming
          set-option -g allow-rename off

          # Status bar
          set -g @ACCENT_COL "#737c73"
          set -g @ACTIVE_BORDER_COL "fg=#a292a3"
          set -g @ALERT_COL "#c4746e"
          set -g @BG_BAR_COL "#282727"
          set -g @BG_PANE_COL "#1D1C19"
          set -g @INACTIVE_BORDER_COL "#625e5a"
          set -g @SELECTION_COL "#393836"
          set -g @TEXT_COL "#c8c093"

          set -g @ICON_PD " "
          set -g @LEFT_SEP ""
          set -g @RIGHT_SEP ""

          # Boder colors
          set-option -g pane-active-border-style "fg=#{@ACTIVE_BORDER_COL}"
          set-option -g pane-border-style "fg=#{@INACTIVE_BORDER_COL}"

          # Message style
          set-option -g message-style "bg=#{@BG_BAR_COL},fg=#{@TEXT_COL}"

          # Prompt cursor colour
          set-option -g prompt-cursor-colour "#737c73"

          # Status bar
          set-option -g status-position top
          set-option -g status-left-length 24
          set-option -g status-left "#{@ICON_PD}#{?client_prefix,#[fg=#{@ALERT_COL}],#[fg=#{@ACCENT_COL}]}#[bg=default]#{@LEFT_SEP}#{?client_prefix,#[fg=#{@BG_PANE_COL}],#[fg=#{@BG_PANE_COL}]}#{?client_prefix,#[bg=#{@ALERT_COL}],#[bg=#{@ACCENT_COL}]}󱚝  #{=16:session_name}#{?client_prefix,#[fg=#{@ALERT_COL}],#[fg=#{@ACCENT_COL}]}#[bg=default]#{@RIGHT_SEP}#{@ICON_PD}"
          set-option -g status-right ""

          # Transparent status background
          set-option -g status-style bg=default
          set-window-option -g window-status-separator ""
          set-window-option -g window-status-current-format "#[fg=#{@SELECTION_COL},bg=default]#{@LEFT_SEP}#[fg=#{@TEXT_COL},bg=#{@SELECTION_COL}]#I #W#[fg=#{@SELECTION_COL},bg=default]#{@RIGHT_SEP}"
          set-window-option -g window-status-format "#[fg=#{@TEXT_COL},bg=default] #I #W "
          set-window-option -g window-status-activity-style "bold"
          set-window-option -g window-status-bell-style "bold"

          set -g visual-activity off
          set -g visual-bell off
          set -g visual-silence on
        '';

        keyMode = "vi";
        mouse = true;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          yank
        ];

        prefix = "M-Space"; # Set prefix to be Alt-Space
        shell = mkIf zsh.enable "${pkgs.zsh}/bin/zsh";
        terminal = "tmux-256color";
      };
    };
}
