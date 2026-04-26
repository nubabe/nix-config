{ inputs, ... }:

{

  simpleHosts.modules = {
    nixos = [
      inputs.self.nixosModules.default
      inputs.home-manager.nixosModules.default
      inputs.disko.nixosModules.default
      inputs.stylix.nixosModules.default
    ];
    darwin = [
      inputs.self.darwinModules.default
      inputs.home-manager.darwinModules.default
      inputs.stylix.darwinModules.default
    ];
  };

}
