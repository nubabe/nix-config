{ ... }:

{
  flake.modules.nixos.system =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    with lib;

    let
      cfg = config.nubabe.systemSettings;
    in

    {
      options.nubabe.systemSettings.enable = mkEnableOption "nubabe misc system settings";

      config = mkIf cfg.enable {

        environment.systemPackages = with pkgs; [
          git
          neovim
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
    };

}
