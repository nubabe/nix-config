{ inputs, ... }:

{

  flake.modules.nixos.shell =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.shell;
    in
    {

      options.nubabe.shell.enable = mkEnableOption "nubabe shell config";

      config = mkIf cfg.enable {
        nubabe.home-manager.modules = [ { nubabe.shell.enable = true;} ];
        environment.pathsToLink = [ "/share/zsh" ];
      };

    };

}
