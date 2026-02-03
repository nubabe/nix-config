{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.profiles.all;
in

{

  options.nubabe.profiles.all.enable = mkEnableOption "nubabe default host config";

  config = mkIf cfg.enable {

    nubabe.networking.enable = true;

    nubabe.users.enable = true;

    environment.systemPackages = with pkgs; [
      neovim
      git
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    time.timeZone = "Europe/Berlin";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "en_DK.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_MONETARY = "en_IE.UTF-8";
      };
    };

  };
}
