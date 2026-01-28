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
  };
}
