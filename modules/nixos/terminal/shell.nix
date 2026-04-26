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
      cfg = config.nubabe.shell;
    in
    {
      options.nubabe.shell.enable = mkEnableOption "nubabe shell config";

      config = mkIf cfg.enable {
        nubabe.home-manager.modules.shared = [ inputs.self.modules.homeManager.shell ];

        nubabe.users.shell = pkgs.zsh;

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
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        plugins = [
          {
            name = "vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
        ];
      };

      home.shellAliases = {
        l = "ls -la --color=auto";
        sudo = "sudo ";
      };
    };
}
