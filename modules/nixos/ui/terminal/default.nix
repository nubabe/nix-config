{ inputs, ... }:

{

  flake.modules.nixos.terminal =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkOption mkIf types;
      cfg = config.nubabe.ui.terminal;
      allowedTerminals = [ "alacritty" ];
    in

    {
      options.nubabe.ui.terminal = {
        enable = lib.mkEnableOption "terminal emulator";
        default = mkOption {
          type = types.enum allowedTerminals;
          default = "alacritty";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge (
          lib.map (terminal: {
            nubabe.ui.terminal.${terminal}.enable = mkIf (cfg.default == "${terminal}") true;
          }) allowedTerminals
        )
      );
    };

}
