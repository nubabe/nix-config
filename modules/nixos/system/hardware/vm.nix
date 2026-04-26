{ ... }:

{

  flake.modules.nixos.vm =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    inherit (lib) mkEnableOption mkIf;



    let
      cfg = config.nubabe.hardware.vm;
    in

    {

      options.nubabe.hardware.vm.enable = mkEnableOption "nubabe vm configuration";

      config = mkIf cfg.enable {
        services.qemuGuest.enable = true;
      };

    };

}
