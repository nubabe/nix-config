{ inputs, ... }:

{

  flake.modules.nixos.browser =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkOption mkIf types;
      cfg = config.nubabe.graphical.browser;
      allowedBrowsers = [ "brave" ];
    in

    {
      options.nubabe.graphical.browser = {
        enable = lib.mkEnableOption "browser";
        default = mkOption {
          type = types.enum allowedBrowsers;
          default = "brave";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge (
          lib.map (browser: {
            nubabe.graphical.browser.${browser}.enable = mkIf (cfg.default == "${browser}") true;
          }) allowedBrowsers
        )
      );
    };

}
