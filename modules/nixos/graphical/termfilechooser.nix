{ inputs, ... }:

{

  flake.modules.nixos.termfilechooser =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical.termfilechooser;
    in

    {
      options.nubabe.graphical.termfilechooser = {
        enable = mkEnableOption "nubabe termfilechooser config";
        package = lib.mkPackageOption pkgs [ "unstable" "xdg-desktop-portal-termfilechooser" ] { };
      };

      config = mkIf cfg.enable {

        xdg.portal = {
          enable = true;
          extraPortals = [ cfg.package ];
          config = {
            common = {
              "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
            };
          };
        };

        nubabe.home-manager.modules.user = [
          inputs.self.modules.homeManager.termfilechooser
        ];
      };
    };

  flake.modules.homeManager.termfilechooser =
    {
      pkgs,
      config,
      osConfig,
      ...
    }:
    {
      xdg.configFile."xdg-desktop-portal-termfilechooser/config".source =
        (pkgs.formats.ini { }).generate "config"
          {
            filechooser = {
              cmd = "${osConfig.nubabe.graphical.termfilechooser.package}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
              default_dir = "$HOME";
              env = "TERMCMD=${osConfig.nubabe.grapical.terminal.default} --title=termfilechooser -e";
              open_mode = "suggested";
              save_mode = "suggested";
            };
          };
    };

}
