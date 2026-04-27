{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      {
        nubabe.system.disko.systemDisk = {
          enable = true;
          rootSize = "100%";
          homeSize = null;
          swapSize = "8G";
        };
        nubabe.system.tailscale.ipv4 = "100.99.0.1";
      }
    ]
    ++ (with inputs.self.nixosModules; [
      core
      server
      vm
    ]);
  };

}
