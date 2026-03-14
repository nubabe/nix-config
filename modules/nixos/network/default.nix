{ ... }:

{

  flake.modules.nixos.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    with lib;

    let
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
