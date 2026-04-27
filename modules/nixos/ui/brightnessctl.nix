{ ... }:

{
  flake.modules.nixos.brightnessctl =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.ui.brightnessctl;
    in

    {
      options.nubabe.ui.brightnessctl.enable = mkEnableOption "brightnessctl";

      config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.brightnessctl ];
        services.udev.packages = [ pkgs.brightnessctl ];
      };
    };

}
