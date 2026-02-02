{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.hardware.proxmox-vm;
in

{

  options.nubabe.hardware.proxmox-vm.enable = mkEnableOption "nubabe hardware configuration for a Proxmox VM with UEFI";

  config = mkIf cfg.enable {

    services.qemuGuest.enable = true;

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    disko.devices = {
      disk = {
        systemDisk = {
          device = "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "500M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };

  };

}
