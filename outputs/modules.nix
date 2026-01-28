{
  inputs,
  self,
  paths,
  ...
}:

{
  flake.nixosModules = {
    commons = (paths.profiles + "/commons.nix");

    users = import paths.users;

    networking = import paths.network;
    tailscale = import (paths.network + "/tailscale.nix");
  };
}
