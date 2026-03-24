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
        nubabe.home-manager.modules.shared = with inputs.self.modules.homeManager; [
          coreTools
          git
        ];
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

  flake.modules.homeManager.git = {osConfig, ...}: {
    programs.git = {
      enable = true;
      settings = {
        user.email = osConfig.nubabe.users.email;
        user.name = osConfig.nubabe.users.username;
        core.editor = "nvim";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
    home.shellAliases = {
      ga = "git add .";
      gc = "git commit";
      gp = "git push";
    };
  };

}
