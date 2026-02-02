{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.profiles.nubabe;
in

{

  options.nubabe.profiles.nubabe.enable = mkEnableOption "nubabe common settings";

  config = mkIf cfg.enable {

    nubabe = {

      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."tailscale/auth_key".path;
        apiKeyFile = config.sops.secrets."tailscale/api_key".path;
      };

      secrets.enable = true;

      users = {
        enable = true;
        username = "nubabe";
        name = "Nuyan";
        hashedPasswordFile = config.sops.secrets."user_password".path;
      };

    };

  };
}
