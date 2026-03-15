{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      {
        nubabe.profiles = [
          "core"
          "workstation"
          "disko"
        ];
        nubabe.services.tailscale.ipv4 = "100.99.1.1.";
      }
    ];
  };

}
