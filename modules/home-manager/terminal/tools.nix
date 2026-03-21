{ ... }:

{
  flake.modules.homeManager.tools =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.terminal.coreTools;
    in
    {

      options.nubabe.terminal.coreTools.enable =
        mkEnableOption "nubabe home-manager config for default terminal tools";

      config = mkIf cfg.enable {
        home.packages = with pkgs; [ ];
        programs = {
          bat.enable = true;
          btop.enable = true;
          fd.enable = true;
          ripgrep.enable = true;
          zoxide.enable = true;
        };
        home.shellAliases = {
          cd = "z";
          cat = "bat";
        };
      };

    };
}
