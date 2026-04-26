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
      cfg = config.nubabe.graphical.terminal;
      allowedTerminals = [ "alacritty" ];
    in

    {
      options.nubabe.graphical.terminal = {
        enable = lib.mkEnableOption "terminal emulator";
        default = mkOption {
          type = types.enum allowedTerminals;
          default = "alacritty";
        };
      };

      config = mkIf cfg.enable (
        lib.mkMerge (
          lib.map (terminal: {
            nubabe.graphical.terminal.${terminal}.enable = mkIf (cfg.default == "${terminal}") true;
          }) allowedTerminals
        )
      );
    };

}
