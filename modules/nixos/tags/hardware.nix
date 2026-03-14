{ inputs, ... }:

{

  flake.nixosModules = {

    t490 = {
      imports = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
      ];
    };


    vm = {
      nubabe.hardware.vm.enable = true;
    };

    disko = {
      imports = [ inputs.disko.nixosModules.default ];
      nubabe.hardware.diskoSystemDisk.enable = true;
    };

  };


}
