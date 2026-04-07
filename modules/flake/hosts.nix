{
  inputs,
  config,
  lib,
  withSystem,
  ...
}:

let

  inherit (lib)
    mkOption
    types
    literalExpression
    mkDefault
    mapAttrs
    ;

  cfg = config.simpleHosts;

  hostSubmodule = types.submodule {
    options = {

      arch = mkOption {
        type = types.enum [
          "x86_64"
          "aarch64"
        ];
        default = "x86_64";
        example = "aarch64";
        description = "Architecture of the host";
      };

      stateVersion = mkOption {
        type = types.str;
        default = "";
        example = "25.11";
        description = "Option to set system.stateVersion";
      };

      modules = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
        example = literalExpression ''
          [
            ./modules/something.nix
            { config.something = "value"; }
          ]
        '';
        description = "List of modules to import in the host.";
      };

    };
  };

  mkHost =
    name: attrs: system: builder: extraModules:
    withSystem system (
      { pkgs, inputs', ... }:
      builder {
        inherit system;
        specialArgs = { inherit inputs'; };
        modules = [
          {
            networking.hostName = mkDefault name;
            system.stateVersion = attrs.stateVersion;
            nixpkgs.pkgs = pkgs;
          }
        ]
        ++ attrs.modules
        ++ extraModules;
      }
    );

in

{

  options.simpleHosts = {

    modules = {
      nixos = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
        description = "List of modules to get imported into every nixos host.";
      };
      darwin = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
        description = "List of modules to get imported into every darwin host.";
      };
    };

    hosts = {
      nixos = mkOption {
        type = types.attrsOf hostSubmodule;
        default = { };
        description = "An attribute set of nixos configurations to be exposed by the flake.";
      };
      darwin = mkOption {
        type = types.attrsOf hostSubmodule;
        default = { };
        description = "An attribute set of darwin configurations to be exposed by the flake.";
      };
    };

  };

  config.flake = {
    nixosConfigurations = mapAttrs (
      name: attrs:
      mkHost name attrs "${attrs.arch}-linux" inputs.nixpkgs.lib.nixosSystem cfg.modules.nixos
    ) cfg.hosts.nixos;
    darwinConfigurations = mapAttrs (
      name: attrs:
      mkHost name attrs "${attrs.arch}-darwin" inputs.nix-darwin.lib.darwinSystem cfg.modules.darwin
    ) cfg.hosts.darwin;
  };

}
