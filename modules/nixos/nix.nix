{ ... }:

{
  flake.modules.nixos.nix =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    with lib;

    let
      cfg = config.nubabe.nixSettings;
    in

    {
      options.nubabe.nixSettings.enable = mkEnableOption "nubabe nix settings";

      config = mkIf cfg.enable {

        nix = {
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

      };
    };

}
