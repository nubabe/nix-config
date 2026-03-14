{ inputs, ... }:

{

  simpleHosts.hosts.nixos.${builtins.baseNameOf ./.} = {
    arch = "x86_64";
    stateVersion = "25.11";
    modules =
      (with inputs.self.nixosModules; [
        default
        core
        nubabe
        workstation
        disko
        t490
      ])
      ++ [
        { nubabe.services.tailscale.ipv4 = "100.99.1.1."; }
      ];
  };

}
