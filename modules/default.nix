{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware
    ./network
    ./profiles
    ./secrets
    ./services
    ./users
  ];
}
