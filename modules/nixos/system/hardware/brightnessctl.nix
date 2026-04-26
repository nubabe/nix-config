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
      cfg = config.nubabe.hardware.brightnessctl;
    in

    {
      options.nubabe.hardware.brightnessctl.enable = mkEnableOption "brightnessctl";

      config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.brightnessctl ];
        services.udev.packages = [ pkgs.brightnessctl ];
      };
    };

}
