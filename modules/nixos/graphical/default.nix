{ inputs, ... }:

{

  flake.modules.nixos.graphical =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical;
    in
    {
      options.nubabe.graphical.enable = mkEnableOption "nubabe graphical setup";
      config = mkIf cfg.enable {
        nubabe.home-manager.modules.user = with inputs.self.modules.homeManager; [ browser ];
      };
    };

  flake.modules.homeManager.browser =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.brave ];
    };
}
