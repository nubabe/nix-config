{ inputs, ... }:

{

  flake.modules.nixos.brave =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical.browser.brave;
    in

    {
      options.nubabe.graphical.browser.brave.enable = mkEnableOption "nubabe brave config";

      config = mkIf cfg.enable {
        nubabe.home-manager.modules.user = [ inputs.self.modules.homeManager.brave ];
      };
    };

  flake.modules.homeManager.brave =
    { pkgs, lib, ... }:
    let
      package = pkgs.brave;
    in
    {
      home.packages = [ package ];
    };
}
