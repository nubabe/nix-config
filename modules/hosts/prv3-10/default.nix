{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      {
        nubabe = {
          common.enable = true;
          hardware = {
            disko = {
              systemDisk = {
                enable = true;
                homeSize = null;
                rootSize = "100%";
                swapSize = "8G";
                systemDisk = "/dev/sda";
              };
            };
            vm.enable = true;
          };
          home-manager = {
            enable = true;
            modules = with inputs.self.homeModules; [ core ];
          };
          services = {
            openssh.enable = true;
            tailscale = {
              enable = true;
              ipv4 = "100.99.0.1";
              tags = [ "nixos-server" ];
            };
          };
          users.enable = true;
        };
      }
    ];
  };

}
