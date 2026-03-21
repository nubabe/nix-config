{ ... }:

{

  flake.modules.homeManager.shell =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.terminal.shell;
    in
    {
      options.nubabe.terminal.shell.enable = mkEnableOption "nubabe home-manager shell config";

      config = mkIf cfg.enable {

        home.shell.enableZshIntegration = true;

        programs.zsh = {
          enable = true;

          autocd = true;
          autosuggestion.enable = true;
          defaultKeymap = "viins";
          syntaxHighlighting.enable = true;
        };

        home.shellAliases = {
          vim = "emacsclient -t";
          l = "ls -la --color=auto";
          connect = "nmcli device connect";
          sudo = "sudo ";
        };

      };
    };
}
