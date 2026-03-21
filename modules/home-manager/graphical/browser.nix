{ ... }:

{

  flake.modules.homeManager.browser =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.brave ];
    };

}
