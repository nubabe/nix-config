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
      profiles = {
        all.enable = true;
        server.enable = true;
      };
      hardware.bios.enable = true;
      hardware.bios.disk = "/dev/sda";
      users.username = "nubabe";
    };
    system.stateVersion = "25.11";

  };
}
