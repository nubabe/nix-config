{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

  inputs = [
    inputs.disko.nixosModules.disko

    ./proxmox-vm.nix
  ];

}
