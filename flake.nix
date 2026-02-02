{
  description = "nubabe's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

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
      };
    };
}
