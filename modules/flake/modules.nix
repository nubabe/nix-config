{ inputs, lib, ... }:

let
  inherit (lib) attrValues;
  modules = inputs.self.modules;
in

{

  flake = {
    nixosModules.default = {
      imports = attrValues (modules.generic or { }) ++ attrValues (modules.nixos or { });
    };
    darwinModules.default = {
      imports = attrValues (modules.generic or { }) ++ attrValues (modules.darwin or { });
    };
    homeModules.default = {
      imports = attrValues (modules.homeManager or { });
    };
  };

}
