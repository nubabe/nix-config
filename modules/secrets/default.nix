{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.secrets;
in

{
  options.nubabe.secrets.enable = mkEnableOption "nubabe secrets";

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      age.keyFile = "/var/lib/sops-nix/key.txt";
      secrets."tailscale/auth_key" = { };
      secrets."tailscale/api_key" = { };
      secrets."user_password" = {
        neededForUsers = true;
      };
    };
  };

}
