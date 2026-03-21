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
        environment.pathsToLink = [ "/share/zsh" ];
      };

    };

}
