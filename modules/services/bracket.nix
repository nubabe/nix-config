{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let

  cfg = config.nubabe.services.bracket;

  bracketSource = "/var/lib/bracket";

  # bracketSource = pkgs.fetchFromGitHub {
  #   owner = "evroon";
  #   repo = "bracket";
  #   rev = "v2.2.5";
  #   hash = "sha256-+THp7uVWS5OcEFcmvDWrwmB5CKsTq72t1bRKh6Lgt08=";
  # };

in

{
  options.nubabe.services.bracket = {
    enable = mkEnableOption "Bracket tournament system";
    user = mkOption {
      type = types.str;
      default = "bracket";
      description = "User to run bracket service as.";
    };
  };

  config = mkIf cfg.enable {

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "${cfg.user}";
    };

    users.groups.${cfg.user} = {};

    services.postgresql = {
      enable = true;
      ensureDatabases = [ cfg.user ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services = {

      bracket-backend = {
        description = "Bracket backend";
        after = [
          "syslog.target"
          "network.target"
          "bracket-repo.service"
        ];
        wants = [ "bracket-repo.service" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          ENVIRONMENT = "PRODUCTION";
          PG_DSN = "postgresql://${cfg.user}@localhost:5432/${cfg.user}";
          JWT_SECRET = "c243e9d8a98232fb90ee8ff835390879cbab8dd6d1e47f3d9920400f0f2fa519";
          CORS_ORIGIN_REGEX = "*";
          ADMIN_EMAIL = "nubabe.me@gmail.com";
          ADMIN_PASSWORD = "basket2026";
          ALLOW_USER_REGISTRATION = "false";
          SERVE_FRONTEND = "true";
          API_PREFIX = "/api";
        };

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = "${bracketSource}/bracket/backend";

          ExecStart = "${pkgs.uv}/bin/uv run gunicorn -k uvicorn.workers.UvicornWorker bracket.app:app --bind localhost:8400 --workers 1";

          TimeoutSec = 15;
          Restart = "always";
          RestartSec = 2;

        };

      };

      bracket-frontend = {
        description = "Bracket frontend";
        after = [
          "syslog.target"
          "network.target"
          "bracket-repo.service"
        ];
        wants = [ "bracket-repo.service" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          VITE_API_BASE_URL = "http://192.168.0.168:8400/api";
          MODE_ENV = "production";
        };

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = "${bracketSource}/bracket/frontend";

          ExecStart = "${pkgs.pnpm}/bin/pnpm start";

          TimeoutSec = 15;
          Restart = "always";
          RestartSec = 2;

        };

      };

    };
  };
}
