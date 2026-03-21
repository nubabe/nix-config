{ ... }:

{

  flake.modules.nixos.common =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.common;
    in
    {

      options.nubabe.common.enable = mkEnableOption "nubabe common config";

      config = mkIf cfg.enable {
        nubabe = {
          bootloader.enable = true;
          networking.enable = true;
          nixSettings.enable = true;
          systemSettings.enable = true;
          users = {
            name = "Nuyan";
            username = "nubabe";
            hashedPasswordFile = null;
            initialHashedPassword = null;
            authorizedSSHKeys = [ ];
          };
          tailscale = {
            apiKeyFile = null;
            authKeyFile = null;
          };
        };
      };

    };

}
