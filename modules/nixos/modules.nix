{ inputs, ... }:

{

  simpleHosts.modules = {
    nixos = [
      inputs.self.nixosModules.default
      inputs.home-manager.nixosModules.default
      inputs.disko.nixosModules.default
    ];
  };

}
