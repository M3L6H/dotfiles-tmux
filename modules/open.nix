{ pname, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.m3l6h.${pname}.open = {
    enable = mkOption {
      default = true;
      description = "tmux utility plugin for directly opening highlighted items";
      type = types.bool;
    };
  };

  config =
    let
      parent = config.m3l6h.${pname};
      enable = parent.enable;
      cfg = parent.open;
    in
    mkIf (enable && cfg.enable) {
      programs.tmux.plugins = with pkgs.tmuxPlugins; [
        {
          plugin = open;
        }
      ];
    };
}
