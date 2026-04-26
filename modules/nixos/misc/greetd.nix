{ ... }:

{
  flake.modules.nixos.greetd =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.greetd;
    in

    {
      options.nubabe.greetd.enable = mkEnableOption "nubabe greetd config";

      config = mkIf cfg.enable {
        services.greetd = {
          enable = true;
          useTextGreeter = true;
          settings.default_session.command = "${lib.getExe pkgs.tuigreet}";
        };
      };
    };
}
