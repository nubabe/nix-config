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
      nftables.enable = true;
      firewall = true;
    };
  };
}
