{ ... }:

{

  flake.modules.nixos.bootloader =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    inherit (lib) mkEnableOption mkIf;



    let
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
