{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.profiles.server;
in

{

  options.nubabe.profiles.server.enable = mkEnableOption "nubabe common settings";

  config = mkIf cfg.enable {
    nubabe = {

      services.openssh.enable = true;

      users.authorizedSSHKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJbT2ErzGeM4IKpSpCPTOh4xizMswYLFeIulTS94pI23 nubabe@t490-arch"
      ];

    };

  };
}
