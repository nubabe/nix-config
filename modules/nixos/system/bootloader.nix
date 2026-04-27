{ ... }:

{

  flake.modules.nixos.bootloader =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.system.bootloader;
    in
    {

      options.nubabe.system.bootloader.enable = mkEnableOption "nubabe bootloader";

      config = mkIf cfg.enable {
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };
    };
}
