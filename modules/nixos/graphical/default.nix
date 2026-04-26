{ inputs, ... }:

{

  flake.modules.nixos.graphical =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib)
        mkEnableOption
        mkIf
        mkOption
        types
        ;
      cfg = config.nubabe.graphical;
    in

    {
      options.nubabe.graphical = {
        enable = mkEnableOption "nubabe graphical environment and its defaults";
      };

      config = mkIf cfg.enable {
        nubabe.graphical = {
          wm.enable = true;
          terminal.enable = true;
          browser.enable = true;
          tools.enable = true;
        };
      };
    };

}
