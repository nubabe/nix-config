{ config, pkgs, lib, paths, ... }:

{
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
}
