{ ... }:

{

  flake.nixosModules = {

    core = {
      users.users.nubabe.initialPassword = "test";
      nubabe = {
        bootloader.enable = true;
        core.enable = true;
        home-manager.enable = true;
        networking.enable = true;
        stylix.enable = true;

        services.openssh.port = 2009;
        services.tailscale = {
          enable = true;
          apiKeyFile = null;
          authKeyFile = null;
        };

        shell.enable = true;
        terminal.coreTools.enable = true;

        users = {
          enable = true;
          name = "Nuyan";
          username = "nubabe";
          email = "nubabe.me@gmail.com";
          # hashedPasswordFile = "./_tmppwd";
          # initialHashedPassword = "$y$j9T$EBvOEz17Xq4Ky72Xl83kU0$F0fOsIn7FVHviLOjvtzqEqhkPqUe2O9B3ZOn8ZVQfY6";
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

    workstation = {
      nubabe.graphical = {
        enable = true;
      };
    };

  };
}
