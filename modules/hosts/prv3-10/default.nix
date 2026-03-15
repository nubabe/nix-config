{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      {
        nubabe.profiles = [
          "core"
          "server"
          "vm"
          "disko"
        ];
        nubabe.services.tailscale = {
          ipv4 = "100.99.0.1";
        };
      }
    ];
  };

}
