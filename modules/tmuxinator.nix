{ pname, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.m3l6h.${pname}.tmuxinator = {
    enable = mkOption {
      default = true;
      description = "session creator for tmux";
      type = types.bool;
    };
  };

  config =
    let
      parent = config.m3l6h.${pname};
      enable = parent.enable;
      cfg = parent.tmuxinator;
    in
    mkIf (enable && cfg.enable) {
      home.packages = with pkgs; [
        tmuxinator
      ];

      home.persistence."/persist/home/${config.home.username}" = lib.mkIf parent.impermanence.enable {
        directories = [
          ".config/tmuxinator"
        ];

        allowOther = false;
      };
    };
}
