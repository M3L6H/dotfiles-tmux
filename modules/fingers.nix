{ pname, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.m3l6h.${pname}.fingers = {
    enable = mkOption {
      default = true;
      description = "quickly find common patterns in the scrollback buffer";
      type = types.bool;
    };
  };

  config =
    let
      parent = config.m3l6h.${pname};
      enable = parent.enable;
      cfg = parent.fingers;
    in
    mkIf (enable && cfg.enable) {
      programs.tmux.plugins = with pkgs.tmuxPlugins; [
        {
          plugin = fingers;
          extraConfig = ''
            set -g @fingers-pattern-1 "'(?<match>[^']+)'|\"(?<match>[^\"]+)\""
            set -g @fingers-pattern-2 '^(󰚩  |❮ )(?<match>.{2,})'

            set -g @fingers-hint-style "fg=magenta,bold,underscore"
            set -g @fingers-highlight-style "fg=green"
            set -g @fingers-selected-highlight-style "fg=blue"
            set -g @fingers-backdrop-style "fg=yellow,dim"
          '';
        }
      ];
    };
}
