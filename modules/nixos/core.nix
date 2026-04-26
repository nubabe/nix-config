{ ... }:

{
  flake.modules.nixos.core =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.core;
    in

    {
      options.nubabe.core.enable = mkEnableOption "nubabe core system settings";

      config = mkIf cfg.enable {

        environment.systemPackages = with pkgs; [ ];
        programs.git.enable = true;

        nix = {
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

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
    };

}
