{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.hardware.bios;
in

{

  options.nubabe.hardware.bios = {
    enable = mkEnableOption "nubabe hardware configuration for a computer with BIOS";
    disk = mkOption {
      type = types.str;
      default = "/dev/sda";
      example = "/dev/nvme0n1";
      description = "The disk to install the system on to. Used by disko and GRUB.";
    };
  };

  config = mkIf cfg.enable {

    boot.loader = {
      grub.enable = true;
      grub.devices = [ cfg.disk ];
    };

    disko.devices = {
      disk = {
        systemDisk = {
          device = cfg.disk;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02"; # for grub MBR
                attributes = [ 0 ]; # partition attribute
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
