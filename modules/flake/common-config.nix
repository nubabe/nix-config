{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.globalVars;
in

{

  options.globalVars = {
    username = mkOption {
      type = types.str;
      default = "";
      example = "alice";
      description = "Username used by home-manager, nixos, ...";
    };

    name = mkOption {
      type = types.str;
      default = "";
      example = "Alice";
      description = "Name for user used by home-manager, nixos, ...";
    };
  };

  config.globalVars = {
    username = "nubabe";
    name = "Nuyan";
  };

}
