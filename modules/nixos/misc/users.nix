{ ... }:

{

  flake.modules.nixos.users =
    {
      config,
      lib,
      pkgs,
      options,
      ...
    }:



    let
      inherit (lib) mkEnableOption mkOption types mkIf optional;
      cfg = config.nubabe.users;
      userOpts = options.users.users.type.getSubOptions [ ];
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
          inherit (userOpts.description) type description;
          default = "nixos";
          example = "Alice";
        };

        email = mkOption {
          type = types.str;
          default = null;
          example = "alice@example.com";
          description = "Email used for git, etc.";
        };

        hashedPasswordFile = mkOption {
          inherit (userOpts.hashedPasswordFile) type description default;
        };

        initialHashedPassword = mkOption {
          inherit (userOpts.initialHashedPassword) type description default;
          example = "$y$j9T$Q5yehP0GeReQZ9lkC2CNa1$JW2wFazO6DPLrSQmvunM4U1kQ1FT0QMuDzCf.sMGeq2";
        };

        authorizedSSHKeys = mkOption {
          inherit (userOpts.openssh.authorizedKeys.keys)
            type
            description
            default
            example
            ;
        };

        shell = mkOption {
          inherit (userOpts.shell)
            type
            description
            default
            example
            ;
        };
      };

      config = mkIf cfg.enable {
        users.users.${cfg.username} = {
          isNormalUser = true;
          description = cfg.name;
          extraGroups = [
            "wheel"
            "video"
          ]
          ++ (optional config.networking.networkmanager.enable "networkmanager");
          packages = with pkgs; [ ];
          openssh.authorizedKeys.keys = cfg.authorizedSSHKeys;
          hashedPasswordFile = cfg.hashedPasswordFile;
          initialHashedPassword = cfg.initialHashedPassword;
          shell = cfg.shell;
        };

        users.users.root.shell = cfg.shell;

      };
    };

}
