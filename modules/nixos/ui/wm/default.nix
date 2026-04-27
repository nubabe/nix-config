{ inputs, ... }:

{

  flake.modules.nixos.wm =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkOption mkIf types;
      cfg = config.nubabe.ui.wm;
      allowedWms = [ "hyprland" ];
    in

    {
      options.nubabe.ui.wm = {
        enable = lib.mkEnableOption "window manager";
        default = mkOption {
          type = types.enum allowedWms;
          default = "hyprland";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge (
          lib.map (wm: {
            nubabe.ui.wm.${wm}.enable = mkIf (cfg.default == "${wm}") true;
          }) allowedWms
        )
      );
    };

}
