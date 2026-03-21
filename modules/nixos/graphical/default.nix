{ ... }:

{

  flake.modules.nixos.graphical =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical;
    in
    {
      options.nubabe.graphical.enable = mkEnableOption "nubabe graphical setup";
      config = mkIf cfg.enable {};
    };

}
