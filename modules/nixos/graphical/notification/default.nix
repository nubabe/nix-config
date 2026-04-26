{ inputs, ... }:

{

  flake.modules.nixos.notification =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkOption mkIf types;
      cfg = config.nubabe.graphical.notification;
      hmModules = inputs.self.modules.homeManager;
    in

    {
      options.nubabe.graphical.notification = {
        enable = lib.mkEnableOption "notification server";
        default = mkOption {
          type = types.enum [ "mako" ];
          default = "mako";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge [
          (mkIf (cfg.default == "mako") {
            nubabe.home-manager.modules.user = [
              hmModules.mako
            ];
          })
        ]
      );
    };

}
