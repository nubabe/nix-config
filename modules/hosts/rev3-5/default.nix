{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
      {
        nubabe.system.disko.systemDisk = {
          enable = true;
          rootSize = "64G";
          homeSize = "100%";
          swapSize = "16G";
        };
        nubabe.system.tailscale.ipv4 = "100.99.1.1";
      }
    ]
    ++ (with inputs.self.nixosModules; [
      core
      workstation
      vm
    ]);
  };

}
