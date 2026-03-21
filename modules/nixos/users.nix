{ ... }:

{

  flake.modules.nixos.users =
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

        hashedPasswordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/secrets/hashed_user_password";
          description = "Path to a file containing a hashed password. See users.users.<name>.hashedPasswordFile.";
        };

        initialHashedPassword = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "$y$j9T$Q5yehP0GeReQZ9lkC2CNa1$JW2wFazO6DPLrSQmvunM4U1kQ1FT0QMuDzCf.sMGeq2";
          description = "Hashed password. See users.users.<name>.initialHashedPassword";
        };

        authorizedSSHKeys = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "ssh-rsa AAAAB3NzaC1yc2etc/etc/etcjwrsh8e596z6J0l7 example@host"
            "ssh-ed25519 AAAAC3NzaCetcetera/etceteraJZMfk3QPfQ foo@bar"
          ];
          description = "List of public SSH keys (alias for users.users.<username>.openssh.authorizedKeys.keys).";
        };
      };

      config = mkIf cfg.enable {
        users.users.${cfg.username} = {
          isNormalUser = true;
          description = cfg.name;
          extraGroups = [
            "wheel"
          ]
          ++ (optional config.networking.networkmanager.enable "networkmanager");
          packages = with pkgs; [ ];
          openssh.authorizedKeys.keys = cfg.authorizedSSHKeys;
          hashedPasswordFile = cfg.hashedPasswordFile;
          initialHashedPassword = cfg.initialHashedPassword;
          shell = pkgs.zsh;
        };

        programs.zsh.enable = true;
      };
    };

}
