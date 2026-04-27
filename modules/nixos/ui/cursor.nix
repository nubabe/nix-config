{ inputs, ... }:

{
  flake.modules.nixos.cursor =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.ui.cursor;
    in

    {
      options.nubabe.ui.cursor.enable = mkEnableOption "nubabe cursor config";

      config = mkIf cfg.enable {
        nubabe.home-manager.modules.user = [ inputs.self.modules.homeManager.cursor ];
      };
    };

  flake.modules.homeManager.cursor =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        package = pkgs.graphite-cursors;
        name = "graphite-dark";
        hyprcursor.enable = true;
        gtk.enable = true;
        size = 24;
      };
    };

}
