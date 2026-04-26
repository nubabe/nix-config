{ ... }:

{

  flake.modules.nixos.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.networking;
    in

    {

      options.nubabe.networking.enable = mkEnableOption "nubabe specific networking";

      config = mkIf cfg.enable {
        networking = {
          firewall.enable = true;
          nftables.enable = true;
        };
      };
    };

}
