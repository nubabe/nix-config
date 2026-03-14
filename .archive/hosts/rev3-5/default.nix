{
  inputs,
  ...
}:
{
  system = "x86_64-linux";
  branch = "stable";
  extraModules = [
    ./disko.nix
    ./hardware.nix
    inputs.disko.nixosModules.disko
  ];
  hostConfig = {
    nubabe.services.tailscale = {
      ipv4 = "100.99.10.2";
      tags = [ "nixos-server" ];
    };
    nubabe.profiles = {
      all.enable = true;
      server.enable = true;
      nubabe.enable = true;
    };
    services.qemuGuest.enable = true;
    system.stateVersion = "25.11";
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

  };
}
