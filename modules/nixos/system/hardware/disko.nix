{ ... }:

{

  flake.modules.nixos.disko =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    inherit (lib) mkEnableOption mkOption types mkIf;



    let
      cfg = config.nubabe.hardware.disko.systemDisk;
    in

    {

      options.nubabe.hardware.disko.systemDisk = {
        enable = mkEnableOption "nubabe system disk partitioning";
        systemDisk = mkOption {
          type = types.str;
          default = "/dev/sda";
          example = "/dev/disk/by-id/nvme-INTEL_SSDPEKKF256G8L_BTHP93041FG Y256B";
          description = "Disk to use for the file system.";
        };
        rootSize = mkOption {
          type = types.str;
          default = "100%";
          example = "32G";
          description = "Size of root partition.";
        };
        swapSize = mkOption {
          type = types.nullOr types.str;
          default = "8G";
          example = null;
          description = "Size of swap partition, if not null.";
        };
        homeSize = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "100%";
          description = "Size of home partition, if not null.";
        };
      };

      config = mkIf cfg.enable {

        disko.devices = {
          disk = {
            systemDisk = {
              device = cfg.systemDisk;
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
                  swap = mkIf (cfg.swapSize != null) {
                    size = cfg.swapSize;
                    content = {
                      type = "swap";
                      discardPolicy = "both";
                    };
                  };
                  root = {
                    size = cfg.rootSize;
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/";
                    };
                  };
                  home = mkIf (cfg.homeSize != null) {
                    size = cfg.homeSize;
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/home";
                    };
                  };
                };
              };
            };
          };
        };
      };

    };

}
