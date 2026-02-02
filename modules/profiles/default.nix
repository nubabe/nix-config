{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./all.nix

    ./nubabe.nix

    ./server.nix
  ];
}
