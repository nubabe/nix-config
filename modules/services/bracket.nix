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

    environment.systemPackages = [ inputs.compose2nix.packages.${pkgs.system}.default ];

    # users.users.${cfg.user} = {
    #   isSystemUser = true;
    # };

    # services.postgresql = {
    #   enable = true;
    #   ensureDatabases = [ cfg.user ];
    #   ensureUsers = [
    #     {
    #       name = cfg.user;
    #       ensureDBOwnership = true;
    #     }
    #   ];
    # };

    # systemd.services = {

    #   bracket-backend = {
    #     description = "Bracket backend";
    #     after = [
    #       "syslog.target"
    #       "network.target"
    #       "bracket-repo.service"
    #     ];
    #     wants = [ "bracket-repo.service" ];
    #     wantedBy = [ "multi-user.target" ];

    #     serviceConfig = {
    #       Type = "simple";
    #       User = cfg.user;
    #       WorkingDirectory = "${bracketSource}/bracket/backend";

    #       ExecStart = "${pkgs.uv}/bin/uv run gunicorn -k uvicorn.workers.UvicornWorker bracket.app:app --bind localhost:8400 --workers 1";

    #       Environment = "ENVIRONMENT=PRODUCTION";
    #       TimeoutSec = 15;
    #       Restart = "always";
    #       RestartSec = 2;

    #     };

    #   };

    #   bracket-frontend = {
    #     description = "Bracket frontend";
    #     after = [
    #       "syslog.target"
    #       "network.target"
    #       "bracket-repo.service"
    #     ];
    #     wants = [ "bracket-repo.service" ];
    #     wantedBy = [ "multi-user.target" ];

    #     serviceConfig = {
    #       Type = "simple";
    #       User = cfg.user;
    #       WorkingDirectory = "${bracketSource}/bracket/frontend";

    #       ExecStart = "${pkgs.pnpm}/bin/pnpm start";

    #       Environment = "NODE_ENV=production";
    #       TimeoutSec = 15;
    #       Restart = "always";
    #       RestartSec = 2;

    #     };

    #   };

    # };
  };
}
