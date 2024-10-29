{
  description = "Home Manager Extension";

  outputs = { self, ... }:
    {
      homeManagerModules = rec {
        nix-index = ./modules/programs/nix-index.nix;
        xonsh = ./modules/programs/xonsh.nix;
        yazi = ./modules/programs/yazi.nix;
        zoxide = ./modules/programs/zoxide.nix;
        all = { ... }: {
          imports = [
            nix-index
            xonsh
            yazi
            zoxide
          ];
        };
        default = all;
      };
    };
}
