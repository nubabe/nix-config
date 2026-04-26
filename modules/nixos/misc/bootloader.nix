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
      cfg = config.nubabe.bootloader;
    in
    {

      options.nubabe.bootloader.enable = mkEnableOption "nubabe bootloader";

      config = mkIf cfg.enable {
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };
    };
}
