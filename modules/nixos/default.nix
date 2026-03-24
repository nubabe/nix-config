{ ... }:

{

  flake.nixosModules = {

    core = {
      nubabe = {
        bootloader.enable = true;
        core.enable = true;
        coreTools.enable = true;
        home-manager.enable = true;
        networking.enable = true;

        services.openssh.port = 2009;
        services.tailscale = {
          enable = true;
          apiKeyFile = null;
          authKeyFile = null;
        };

        shell.enable = true;

        users = {
          enable = true;
          name = "Nuyan";
          username = "nubabe";
          hashedPasswordFile = null;
          initialHashedPassword = null;
          authorizedSSHKeys = [ ];
        };
      };
    };

    vm = {
      nubabe.hardware.vm.enable = true;
    };

    server = {
      nubabe = {
        services = {
          openssh.enable = true;
          tailscale.tags = [ "nixos-server" ];
        };
      };
    };

    graphical = {
      nubabe.graphical.enable = true;
    };

  };
}
