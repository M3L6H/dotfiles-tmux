{ pname, ... }:
{
  config,
  lib,
  ...
}:
with lib;
{
  options.m3l6h.${pname}.line-numbers = {
    enable = mkOption {
      default = true;
      description = "relative line numbers in the scrollback buffer";
      type = types.bool;
    };
  };

  config =
    let
      parent = config.m3l6h.${pname};
      enable = parent.enable;
      cfg = parent.line-numbers;
    in
    mkIf enable {
      home.file.".local/bin/line-numbers.sh" = mkIf cfg.enable {
        executable = true;
        source = ./line-numbers.sh;
      };

      programs.tmux.extraConfig = ''
        # Enter copy mode with Alt-v
        bind-key -n 'M-v' ${
          if cfg.enable then "run-shell $HOME/.local/bin/line-numbers.sh" else "copy-mode"
        }
      '';
    };
}
