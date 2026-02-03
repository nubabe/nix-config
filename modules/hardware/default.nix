{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.disko.nixosModules.disko

    ./proxmox-vm.nix
    ./bios.nix
    ./uefi.nix
  ];

}
