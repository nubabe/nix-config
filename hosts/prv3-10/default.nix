{
  inputs,
  ...
}:
{
  system = "x86_64-linux";
  branch = "stable";
  extraModules = [
  ];
  hostConfig = {
    nubabe.services.tailscale.ipv4 = "100.99.10.2";
    imports = [ /etc/nixos/hardware-configuration.nix ];
    system.stateVersion = "25.05";
    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };
}
