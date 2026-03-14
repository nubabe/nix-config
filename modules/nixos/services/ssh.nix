{
  ...
}:

{
  flake.modules.nixos.ssh =
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
        port = mkOption {
          type = types.int;
          default = 22;
          example = 1234;
          description = "Port on which the SSH daemon listens.";
        };
      };

      config = mkIf cfg.enable {
        services.openssh = {
          enable = true;
          ports = [ cfg.port ];
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

    };

}
