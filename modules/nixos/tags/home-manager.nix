{
  inputs,
  ...
}:

{

  flake.nixosModules.home = {
    imports = [
      inputs.home-manager.nixosModules.default
    ];
  };

}
