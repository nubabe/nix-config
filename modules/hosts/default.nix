{
  inputs,
  lib,
  rootPath,
  ...
}:
let
  path = ./.;

  entries = builtins.attrNames (builtins.readDir path);
  hosts = builtins.filter (
    hostname: builtins.pathExists (path + "/${hostname}/metadata.nix")
  ) entries;
  hostMeta = builtins.map (host: (import (path + "/${host}/metadata.nix"))) hosts;

  configurations = builtins.map (
    host:
    let
      isUnstable = host.isUnstable or false;
      system = host.system or "unknown";
    in
    if system == "x86_64-linux" then
      host
      // {
        flakeOutput = "nixosConfigurations";
        systemBuilder = (
          if isUnstable then inputs.nixpkgs-unstable.lib.nixosSystem else inputs.nixpkgs.lib.nixosSystem
        );
      }
    else if system == "aarch64-darwin" then
      host
      // {
        flakeOutput = "darwinConfigurations";
        systemBuilder = inputs.nix-darwin.lib.darwinSystem;
      }
    else
      host
  ) hostMeta;
in
{

  flake = lib.foldl' lib.recursiveUpdate { } (
    builtins.map (host: {
      ${host.flakeOutput}.${host.hostname} = host.systemBuilder {
        system = host.system;
        modules = [
          (path + "/${host.hostname}/configuration.nix")
        ];
      };
    }) configurations
  );
}
