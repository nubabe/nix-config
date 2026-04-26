{ inputs, lib, ... }:

let
  inherit (lib) mapAttrs attrByPath splitString;

  stringToAttr = attrName: attrSet: attrByPath (splitString "." attrName) null attrSet;
in

{

  flake.lib = {
    perHostOptionValue =
      option:
      mapAttrs (name: cfg: attrByPath (splitString "." option) null cfg.config) (
        inputs.self.nixosConfigurations // inputs.self.darwinConfigurations
      );
  };

}
