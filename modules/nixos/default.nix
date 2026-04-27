{ ... }:

{

  flake.nixosModules = {

    core = {
      users.users.nubabe.initialPassword = "test";
      nubabe = {
        home-manager.enable = true;
        system = {
          bootloader.enable = true;
          core.enable = true;
          network.enable = true;
          openssh.port = 2009;
          tailscale = {
            enable = true;
            apiKeyFile = null;
            authKeyFile = null;
          };
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
        ui = {
          stylix.enable = true;
          shell.enable = true;
          coreTools.enable = true;
        };
      };
    };

    vm = {
      nubabe.system.vm.enable = true;
    };

    server = {
      nubabe = {
        system = {
          openssh.enable = true;
          tailscale.tags = [ "nixos-server" ];
        };
      };
    };

    workstation = {
      nubabe.ui = {
        wm.enable = true;
        browser.enable = true;
        terminal.enable = true;
        termfilechooser.enable = true;

        keepassxc.enable = true;
      };
    };

  };
}
