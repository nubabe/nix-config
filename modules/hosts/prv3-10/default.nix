{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules = [
      {
        nubabe = {
          services.tailscale = {
            ipv4 = "100.99.0.1";
          };
        };
      }
    ];
  };

}
