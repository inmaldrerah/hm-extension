{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.yazi;

  xonshIntegration = ''
    def __yazi_init():
      def yy(args):
        tmp = $(mktemp -t "yazi-cwd.XXXXX").strip()
        $[yazi @(args) @(f"--cwd-file={tmp}")]
        cwd = fp"{tmp}".read_text()
        if cwd != "" and cwd != $PWD:
          xonsh.dirstack.cd((cwd,))
        $[rm -f -- @(tmp)]

      aliases['yy'] = yy
    __yazi_init()
    del __yazi_init
  '';
in {
  options.programs.yazi = {
    enableXonshIntegration = mkEnableOption "Xonsh integration";
  };

  config = mkIf cfg.enable {
    programs.xonsh.rcFiles."yazi.xsh".text =
      mkIf cfg.enableXonshIntegration xonshIntegration;
  };
}
