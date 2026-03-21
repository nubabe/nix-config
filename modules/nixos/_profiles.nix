{ config, ... }:

let
  globalVars = config.globalVars;
in

{

  flake.modules.nixos.profiles =
    { config, lib, ... }:
    let
      inherit (lib)
        mkOption
        types
        literalExpression
        mkIf
        mkMerge
        elem
        ;
      cfg = config.nubabe.profiles;

      allowedProfiles = [
        "core"
        "workstation"
        "server"
        "disko"
        "vm"
      ];

      mkIf' = profile: configuration: mkIf (elem profile cfg) configuration;

    in
    {
      options.nubabe.profiles = mkOption {
        type = types.listOf (types.enum allowedProfiles);
        default = [ ];
        example = literalExpression ''
          [ "core" "server" "vm" ]
        '';
        description = "List of profile names to enable.";
      };

      config = mkMerge [
        (mkIf' "core" {
          nubabe = {
            networking.enable = true;
            nixSettings.enable = true;
            systemSettings.enable = true;
            users.enable = true;
            bootloader.enable = true;
            services = {
              openssh.port = 2009;
              tailscale.enable = true;
            };
            users = {
              inherit (globalVars) username name;
              authorizedSSHKeys = [ ];
            };
            home-manager.enable = true;
            home-manager.profiles = [ "core" ];
            shell.enable = true;
          };
        })
        (mkIf' "server" {
          nubabe.services = {
            openssh.enable = true;
            tailscale.tags = [
              "nixos-server"
            ];
          };
        })
        (mkIf' "vm" { nubabe.hardware.vm.enable = true; })
        (mkIf' "disko" { nubabe.hardware.disko.systemDisk.enable = true; })
        (mkIf' "workstation" {
          nubabe = {
            home-manager.profiles = [ "graphical" ];
            graphical.enable = true;
          };
        })
      ];
    };

}
