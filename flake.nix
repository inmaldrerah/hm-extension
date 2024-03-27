{
  description = "Home Manager Extension";

  outputs = { self, ... }:
    {
      homeManagerModules = rec {
        xonsh = ./modules/programs/xonsh.nix;
        yazi = ./modules/programs/yazi.nix;
        zoxide = ./modules/programs/zoxide.nix;
        all = { ... }: {
          imports = [
            xonsh
            yazi
            zoxide
          ];
        };
        default = all;
      };
    };
}
