{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nix-index;

  xonshIntegration = ''
    def __nix_index_init():
      source-bash ${pkgs.writeText "nix-index-command-not-found" ''
        source ${cfg.package}/etc/profile.d/command-not-found.sh
        nix_index_command_not_found_handler_return_0() {
          command_not_found_handle "$@" || true
        }
      ''}
      bash_command_not_found = aliases.pop("nix_index_command_not_found_handler_return_0")
      @events.on_command_not_found
      def _(cmd: list[int]) -> None:
        bash_command_not_found(cmd)
    __nix_index_init()
  '';
in {
  options.programs.nix-index = {
    enableXonshIntegration = mkEnableOption "Xonsh integration" // {  
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.xonsh.rcFiles."nix-index.xsh".text =
      mkIf cfg.enableXonshIntegration xonshIntegration;
  };
}
