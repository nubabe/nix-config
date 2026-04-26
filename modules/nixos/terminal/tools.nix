{ inputs, ... }:

{

  flake.modules.nixos.coreTools =
    { config, lib, ... }:
    let
      cfg = config.nubabe.terminal.coreTools;
    in
    {
      options.nubabe.terminal.coreTools.enable = lib.mkEnableOption "nubabe terminal core tools";

      config = lib.mkIf cfg.enable {
        nubabe.home-manager.modules = with inputs.self.modules.homeManager; {
          shared = [
            coreTools
            git
            nixmate
            neovim
          ];
          user = [ ssh ];
        };
      };
    };

  flake.modules.homeManager.coreTools =
    { pkgs, ... }:
    {
      programs = {
        bat.enable = true;
        btop.enable = true;
        fd.enable = true;
        jq.enable = true;
        ripgrep.enable = true;
        zoxide.enable = true;
        yazi.enable = true;
      };
      home.shellAliases = {
        cd = "z";
        cat = "bat";
      };
    };

  flake.modules.homeManager.neovim = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  flake.modules.homeManager.git =
    { osConfig, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user.email = osConfig.nubabe.users.email;
          user.name = osConfig.nubabe.users.username;
          core.editor = "$EDITOR";
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          help.autocorrect = 15;
        };
      };
      home.shellAliases = {
        ga = "git add .";
        gc = "git commit";
        gp = "git push";
        gs = "git status";
      };
    };

  flake.modules.homeManager.nixmate =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = [ pkgs.unstable.nixmate ];
      xdg.configFile."nixmate/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
        theme = "transparent";
        language = "english";
        layout = "auto";
        welcome_shown = true;
        ai_enabled = false;
        nixpkgs_channel = "auto";
      };
    };

  flake.modules.homeManager.ssh =
    { lib, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = lib.mapAttrs (name: cfg: {
          port = cfg.services.openssh.port;
          hostname = cfg.services.tailscale.ipv4;
          user = cfg.users.username;
        }) (inputs.self.lib.perHostOptionValue "nubabe");
      };
    };

}
