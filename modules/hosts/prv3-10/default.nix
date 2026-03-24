{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      {
        nubabe.hardware.disko.systemDisk = {
          enable = true;
          rootSize = "100%";
          homeSize = null;
          swapSize = "8G";
        };
      }
    ]
    ++ (with inputs.self.nixosModules; [
      core
      server
      vm
    ]);
  };

}
