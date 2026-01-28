{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.commons;
in

{

  options.nubabe.commons.enable = mkEnableOption "nubabe common settings";

  config = mkIf cfg.enable {
    nubabe = {
      services.tailscale = {
        enable = true;
        apiKeyFile = /run/secrets/tailscale_api_key;
        authKeyFile = /run/secrets/tailscale_auth_key;
      };

      networking.enable = true;

      users = {
        enable = true;
        username = "nubabe";
        name = "Nuyan";
      };

    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    environment.systemPackages = with pkgs; [
      neovim
    ];

    services.openssh.enable = true;
    services.openssh.ports = [ 2009 ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
