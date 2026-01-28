{
  inputs,
  ...
}:
{
  system = "x86_64-linux";
  branch = "unstable";
  extraModules = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
  ];
  cfg = {};
}
