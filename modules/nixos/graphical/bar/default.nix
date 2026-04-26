{ inputs, ... }:

{

  flake.modules.nixos.bar =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkOption mkIf types;
      cfg = config.nubabe.graphical.bar;
      hmModules = inputs.self.modules.homeManager;
    in

    {
      options.nubabe.graphical.bar = {
        enable = lib.mkEnableOption "status bar";
        default = mkOption {
          type = types.enum [ "waybar" ];
          default = "waybar";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge [
          (mkIf (cfg.default == "waybar") {
            nubabe.home-manager.modules.user = [
              hmModules.waybar
            ];
          })
        ]
      );
    };

}
