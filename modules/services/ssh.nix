{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.services.openssh;
in

{
  options.nubabe.services.openssh = {
    enable = mkEnableOption "nubabe openssh settings";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 2009 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers = [ config.nubabe.users.username ];
      };
      extraConfig = ''
        MaxAuthTries 3
      '';
    };
  };

}
