{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.users;
in

{

  options.nubabe.users = {
    enable = mkEnableOption "nubabe users";
    username = mkOption {
      type = types.str;
      default = "nixos";
      example = "alice";
      description = "Username for the default user.";
    };
    name = mkOption {
      type = types.str;
      default = "nixos";
      example = "Alice";
      description = "Name of the default user.";
    };
  };

  config = mkIf cfg.enable {
    users.users = {

      ${cfg.username} = {
        isNormalUser = true;
        description = cfg.name;
        extraGroups = [
          "wheel"
        ]
        ++ (optionals config.networking.networkmanager.enable "networkmanager");
        packages = with pkgs; [ ];
      };

    };
  };
}
