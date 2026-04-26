{ ... }:

{

  flake.modules.nixos.audio =
    { config, lib, ... }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.audio;
    in

    {
      options.nubabe.audio.enable = mkEnableOption "nubabe audio setup";

      config = mkIf cfg.enable {
        services.pipewire = {
          enable = true;
          audio.enable = true;
          wireplumber.enable = true;

          pulse.enable = true;
          alsa.enable = true;
          jack.enable = true;
        };
      };
    };

}
