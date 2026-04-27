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
      cfg = config.nubabe.ui.browser.brave;
    in

    {
      options.nubabe.ui.browser.brave.enable = mkEnableOption "nubabe brave config";

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
