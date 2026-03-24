{ inputs, ... }:

{

  flake.modules.nixos.coreTools =
    { config, lib, ... }:
    let
      cfg = config.nubabe.terminal.coreTools;
    in
    {
      options.nubabe.terminal.coreTools = lib.mkEnableOption "nubabe terminal core tools";

      config = lib.mkIf cfg.enable {
        nubabe.home-manager.modules.shared = [ inputs.self.modules.homeManager.coreTools ];
      };
    };

  flake.modules.homeManager.coreTools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ ];
      programs = {
        bat.enable = true;
        btop.enable = true;
        fd.enable = true;
        jq.enable = true;
        ripgrep.enable = true;
        zoxide.enable = true;
      };
      home.shellAliases = {
        cd = "z";
        cat = "bat";
      };
    };
}
