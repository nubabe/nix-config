{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
      {
        nubabe = {
          graphical.enable = true;
          hardware = {
            disko = {
              systemDisk = {
                enable = true;
                homeSize = "100%";
                rootSize = "64G";
                swapSize = "8G";
                systemDisk = "/dev/sda";
              };
            };
            vm.enable = false;
          };
          home-manager = {
            enable = true;
            modules = [ ];
          };
          services = {
            openssh = {
              enable = false;
              port = 22;
            };
            tailscale = {
              apiKeyFile = null;
              authKeyFile = null;
              enable = false;
              ipv4 = "100.99.1.1.";
              tags = [ ];
            };
          };
          shell = {
            enable = false;
          };
          users = {
            enable = false;
          };
        };
      }
    ];
  };

}
