{
  ...
}:
{
  system = "x86_64-linux";
  branch = "stable";
  extraModules = [
  ];
  hostConfig = {
    nubabe = {
      services.tailscale = {
        ipv4 = "100.99.10.2";
        tags = [ "nixos-server" ];
      };
      profiles = {
        all.enable = true;
        server.enable = true;
        nubabe.enable = true;
      };
      hardware.proxmox-vm.enable = true;
    };
    system.stateVersion = "25.11";

  };
}
