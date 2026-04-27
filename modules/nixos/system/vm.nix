{ ... }:

{

  flake.modules.nixos.vm =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.system.vm;
    in

    {

      options.nubabe.system.vm.enable = mkEnableOption "nubabe vm configuration";

      config = mkIf cfg.enable {
        services.qemuGuest.enable = true;
      };

    };

}
