{
  inputs,
  self,
  paths,
  lib,
  ...
}:
let
  branches = {
    stable = inputs.nixpkgs.lib.nixosSystem;
    unstable = inputs.nixpkgs-unstable.lib.nixosSystem;
  };

  hosts = lib.mapAttrs (name: type: import (paths.hosts + "/${name}") { inherit inputs; }) (
    builtins.readDir paths.hosts
  );

  linuxHosts = lib.filterAttrs (host: cfg: (builtins.match ".*-linux" cfg.system) != null) hosts;

  modules = [
  ]
  ++ (builtins.attrValues self.nixosModules);
in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    host: cfg:
    branches.${cfg.branch} {
      system = cfg.system;
      specialArgs = { inherit inputs; };
      modules =
        modules
        ++ cfg.extraModules
        ++ [
          {
            networking.hostName = host;
            nubabe.commons.enable = true;
          }
          cfg.hostConfig
        ];
    }
  ) linuxHosts;
}
