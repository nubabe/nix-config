{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.services.bracket;
in

{
  options.nubabe.services.bracket.enable = mkEnableOption "Bracket tournament management";

  config = mkIf cfg.enable {
    # 1. Enable Docker
    virtualisation.docker.enable = true;

    # 2. Define the Containers
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {

        # Postgres Service
        "postgres" = {
          image = "postgres:latest";
          environment = {
            POSTGRES_DB = "bracket_dev";
            POSTGRES_PASSWORD = "bracket_dev";
            POSTGRES_USER = "bracket_dev";
          };
          volumes = [
            "bracket_pg_data:/var/lib/postgresql/data"
          ];
          # Automatically restart
          extraOptions = [ "--restart=always" ];
        };

        # Bracket Service
        "bracket" = {
          image = "ghcr.io/evroon/bracket:latest";
          dependsOn = [ "postgres" ];
          ports = [ "8400:8400" ];
          environment = {
            ENVIRONMENT = "DEVELOPMENT";
            CORS_ORIGINS = "http://localhost:8400";
            PG_DSN = "postgresql://bracket_dev:bracket_dev@postgres:5432/bracket_dev";
            SERVE_FRONTEND = "true";
            API_PREFIX = "/api";
          };
          volumes = [
            "bracket_static_data:/app/static"
          ];
          extraOptions = [ "--restart=unless-stopped" ];
        };
      };
    };
  };
}
