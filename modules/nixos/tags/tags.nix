{ inputs, config, ... }:

{

  flake.nixosModules = {

    core = {
      nubabe = {
        networking.enable = true;
        nixSettings.enable = true;
        systemSettings.enable = true;
        users.enable = true;
        bootloader.enable = true;
      };
    };

    nubabe = {
      nubabe = {
        services = {
          openssh.port = 2009;
          tailscale.enable = true;
        };
        users = {
          inherit (config.globalVars) username name;
          authorizedSSHKeys = [ ];
        };
      };
    };

    workstation = {
      nubabe = {
        hardware.diskoSystemDisk = {
          rootSize = "64G";
          homeSize = "100%";
          swapSize = "16G";
        };
      };
    };

    server = {
      nubabe = {
        services = {
          openssh.enable = true;
          tailscale.tags = [ "nixos-server" ];
        };
      };
    };

  };

}
