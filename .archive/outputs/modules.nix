{
  inputs,
  self,
  paths,
  ...
}:

{
  flake.nixosModules = {
    modules =
      { ... }:
      {
        _module.args.inputs = inputs;
        imports = [ paths.modules ];
      };
  };
}
