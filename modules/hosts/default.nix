{
  inputs,
  lib,
  paths,
  ...
}:
let
  # Returns list of hosts that have a configuration.nix
  # e.g. [ "host01"  "host02" "host03"]
  hostNames = builtins.filter (
    hostName: builtins.pathExists (paths.hosts + "/${hostName}/configuration.nix")
  ) (builtins.attrNames (builtins.readDir paths.hosts));

  # Returns list of attribute sets
  # e.g. [ { hostName = "..."; system = "..."; isUnstable = true; } ... ]
  rawHostMeta = builtins.map (
    hostName: (import (paths.hosts + "/${hostName}/metadata.nix")) // { inherit hostName; }
  ) hostNames;

  # Returns list of attribute sets,
  # with system build function and flake output name,
  # and null if the host metadata does not contain a valid system attribute
  # e.g. [ { hostName = "..."; systemBuilder = ...; flakeOutput = "..."; } ... ]
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

  # Checks if any item in buildPlans is null and removes it
  validBuildPlans = builtins.filter (buildPlan: buildPlan != null) buildPlans;
in
{

  flake = lib.foldl' lib.recursiveUpdate { } (
    builtins.map (host: {
      ${host.flakeOutput}.${host.hostName} = host.systemBuilder {
        system = host.system;
        specialArgs = { inherit inputs paths; };
        modules = [
          (paths.hosts + "/${host.hostName}/configuration.nix")
          { networking.hostName = host.hostName; }
        ];
      };
    }) validBuildPlans
  );
}
