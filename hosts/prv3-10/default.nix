{
  inputs,
  ...
}:
{
  system = "x86_64-linux";
  branch = "stable";
  extraModules = [
  ];
  cfg = {
    nubabe.services.tailscale.ipv4 = "100.99.10.2";
  };
}
