{
  ...
}:
{
  system = "x86_64-linux";
  branch = "stable";
  extraModules = [
    ./bracket.nix
  ];
  hostConfig = {
    nubabe = {
      profiles = {
        all.enable = true;
        server.enable = true;
      };
      hardware.uefi.enable = true;
      users.username = "nubabe";
      users.initialHashedPassword = "$y$j9T$KsdYlmmKYluOW.rcFknvs1$GiU7K6di9pHHALGb6ZqAVsBBivfaKNGzKKUrTz1wcRD";
      # services.bracket.enable = false;
    };
    system.stateVersion = "25.11";
    networking.networkmanager.enable = true;
    networking.firewall.allowedTCPPorts = [ 8400 3000 ];

  };
}
