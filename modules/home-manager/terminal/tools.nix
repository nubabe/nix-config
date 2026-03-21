{ ... }:

{
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
