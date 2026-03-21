{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
      {
        nubabe = {
          common.enable = true;
          graphical.enable = true;
          hardware = {
            disko = {
              systemDisk = {
                enable = true;
                homeSize = "100%";
                rootSize = "64G";
                swapSize = "16G";
                systemDisk = "/dev/sda";
              };
            };
          };
          home-manager = {
            enable = true;
            modules = with inputs.self.homeModules; [ default ];
          };
          services = {
            tailscale = {
              enable = true;
              ipv4 = "100.99.1.1.";
              tags = [ ];
            };
          };
          users.enable = true;
        };
      }
    ];
  };

}
