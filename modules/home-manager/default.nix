{ ... }:

{

  flake.modules.homeManager.default = {pkgs, ...}: {

    home.packages = [ pkgs.brave ];
  };

}
