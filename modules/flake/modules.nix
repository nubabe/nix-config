{ inputs, lib, ... }:

let
  modules = inputs.self.modules;
in

{

  flake = {
    nixosModules.default = {
      imports = lib.attrValues (modules.generic or {}) ++ lib.attrValues (modules.nixos or {});
    };
    darwinModules.default = {
      imports = lib.attrValues (modules.generic or {}) ++ lib.attrValues (modules.darwin or {});
    };
    homeModules.default = {
      imports = lib.attrValues (modules.homeManager or {});
    };
  };

}
