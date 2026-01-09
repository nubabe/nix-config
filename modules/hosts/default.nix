{
  inputs,
  lib,
  rootPath,
  ...
}:
let
  hostsDir = ./.;

  hostNames = builtins.filter (
    hostName: builtins.pathExists (hostsDir + "/${hostName}/metadata.nix")
  ) (builtins.attrNames (builtins.readDir hostsDir));

  rawHostMeta = builtins.map (
    hostName: (import (hostsDir + "/${hostName}/metadata.nix")) // { inherit hostName; }
  ) hostNames;

  buildPlans = builtins.map (
    hostMeta:
    let
      isUnstable = hostMeta.isUnstable or false;
      system = hostMeta.system or "unknown";
      hostName = hostMeta.hostName;
    in
    if system == "x86_64-linux" then
      {
        flakeOutput = "nixosConfigurations";
        systemBuilder = (
          if isUnstable then inputs.nixpkgs-unstable.lib.nixosSystem else inputs.nixpkgs.lib.nixosSystem
        );
        inherit hostName system;
      }
    else if system == "aarch64-darwin" then
      {
        flakeOutput = "darwinConfigurations";
        systemBuilder = inputs.nix-darwin.lib.darwinSystem;
        inherit hostName system;
      }
    else
      null
  ) rawHostMeta;

  validBuildPlans = builtins.filter (buildPlan: buildPlan != null) buildPlans;
in
{

  flake = lib.foldl' lib.recursiveUpdate { } (
    builtins.map (host: {
      ${host.flakeOutput}.${host.hostName} = host.systemBuilder {
        system = host.system;
        specialArgs = { inherit inputs; };
        modules = [
          (hostsDir + "/${host.hostName}/configuration.nix")
          { networking.hostName = host.hostName; }
        ];
      };
    }) validBuildPlans
  );
}
