
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.hardware.uefi;
in

{

  options.nubabe.hardware.uefi.enable =
    mkEnableOption "nubabe hardware configuration for a Proxmox VM with UEFI";

  config = mkIf cfg.enable {

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
              swap = {
                size = "8G";
                content = {
                  type = "swap";
                  discardPolicy = "both";
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
