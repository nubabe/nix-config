{
  description = "nubabe's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # nix-darwin = {
    #   url = "github:LnL7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = builtins.map (file: ./outputs + "/${file}") (
        builtins.attrNames (builtins.readDir ./outputs)
      );
      _module.args.paths = rec {
        root = ./.;
        modules = root + "/modules";
        hosts = root + "/hosts";
        services = modules + "/services";
        profiles = modules + "/profiles";
        hardware = modules + "/hardware";
        network = modules + "/network";
        misc = modules + "/misc";
        users = modules + "/users";
      };
    };
}
