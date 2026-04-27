{ inputs, ... }:

{

  flake.modules.nixos.launcher =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkOption mkIf types;
      cfg = config.nubabe.ui.launcher;
      hmModules = inputs.self.modules.homeManager;
    in

    {
      options.nubabe.ui.launcher = {
        enable = lib.mkEnableOption "app launcher";
        default = mkOption {
          type = types.enum [ "rofi" ];
          default = "rofi";
        };
        command = mkOption {
          type = types.str;
          default = "";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge [
          (mkIf (cfg.default == "rofi") {
            nubabe.ui.launcher.command = "rofi -show drun";
            nubabe.home-manager.modules.user = [
              hmModules.rofi
            ];
          })
        ]
      );
    };

}
