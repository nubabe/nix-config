{ inputs, ... }:

{

  systems = [ "x86_64-linux" ];

  imports = with inputs; [
    flake-parts.flakeModules.modules
    home-manager.flakeModules.default
    nix-darwin.flakeModules.default
  ];

}
