{ ... }:

{

  flake.modules.homeManager.browser =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical.browser;
    in

    {

      options.nubabe.graphical.browser.enable = mkEnableOption "nubabe home-manager browser config";

      config = mkIf cfg.enable { home.packages = [ pkgs.brave ]; };

    };

}
