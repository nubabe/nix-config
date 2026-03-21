{ ... }:

{
  flake.modules.homeManager.shell = {
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
}
