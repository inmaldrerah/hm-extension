{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.zoxide;

in {
  options.programs.zoxide = {
    enableXonshIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Xonsh integration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.xonsh.rcFiles."zoxide.xsh".text =
      mkIf cfg.enableXonshIntegration ''
        execx($(${cfg.package}/bin/zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')
      '';
  };
}
