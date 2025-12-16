{ pname, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.m3l6h.${pname}.sessionx = {
    enable = mkOption {
      default = true;
      description = "tmux session manager with fuzzy finding";
      type = types.bool;
    };
  };

  config =
    let
      parent = config.m3l6h.${pname};
      enable = parent.enable;
      cfg = parent.sessionx;

      # integration with my custom zsh
      zsh =
        config.m3l6h.zsh or {
          zoxide.enable = false;
        };
    in
    mkIf (enable && cfg.enable) {
      home.packages = with pkgs; [
        bat # Used for syntax highlighting in preview
      ];
      programs.fzf.enable = true; # Used for fuzzy finding

      programs.tmux.plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tmux-sessionx;
          extraConfig = ''
            set -g @sessionx-bind "C-o"
            set -g @sessionx-prefix off
            set -g @sessionx-bind-tmuxinator-list "ctrl-t"

            set -g @sessionx-tmuxinator-mode "on"
            ${if zsh.zoxide.enable then "set -g @sessionx-zoxide-mode 'on'" else ""}
          '';
        }
      ];
    };
}
