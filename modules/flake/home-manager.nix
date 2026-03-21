{ inputs, withSystem, ... }:

{

  flake.homeConfigurations.debug = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
    modules = [
      inputs.self.homeModules.default
      {
        home.username = "debug";
        home.homeDirectory = "/home/debug";
        home.stateVersion = "25.11";
      }
    ];
  };

}
