{
  ...
}:

{
  flake.modules.nixos.ssh =
    {
      config,
      lib,
      options,
      ...
    }:

    let
      inherit (lib)
        mkEnableOption
        mkOption
        types
        mkIf
        ;
      cfg = config.nubabe.system.openssh;
      opts = options.services.openssh;
    in

    {

      options.nubabe.system.openssh = {
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
            AllowUsers = [ config.nubabe.system.users.username ];
          };
          extraConfig = ''
            MaxAuthTries 3
          '';
        };
      };

    };

}
