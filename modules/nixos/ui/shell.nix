{ inputs, ... }:

{

  flake.modules.nixos.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.ui.shell;
    in
    {
      options.nubabe.ui.shell.enable = mkEnableOption "nubabe shell config";

      config = mkIf cfg.enable {
        nubabe.home-manager.modules.shared = [ inputs.self.modules.homeManager.shell ];

        nubabe.system.users.shell = pkgs.zsh;

        programs.zsh.enable = true;
      };
    };

  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.shell.enableZshIntegration = true;

      programs.zsh = {
        enable = true;

        autocd = true;
        autosuggestion.enable = false;
        syntaxHighlighting.enable = true;

        plugins = [
          {
            name = "zsh-vi-mode";
            src = pkgs.zsh-vi-mode;
            # file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
          {
            name = "zsh-autocomplete";
            src = pkgs.zsh-autocomplete;
          }
        ];
      };

      home.shellAliases = {
        l = "ls -la --color=auto";
        sudo = "sudo ";
      };
    };
}
