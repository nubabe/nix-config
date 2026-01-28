{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nubabe.services.tailscale;
in

{
  options.nubabe.services.tailscale = {
    enable = mkEnableOption "nubabe specific Tailscale";
    ipv4 = mkOption {
      type = types.str;
      default = "";
      example = "100.64.10.5";
      description = "IPv4 adress in the 100.64.0.0/10 range to use.";
    };
    apiKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/tailscale_api_key";
      description = "A file containing the API key. Used for setting the Tailscale IP.";
    };
    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/tailscale_auth_key";
      description = "Alias for services.tailscale.authKeyFile";
    };
  };

  config = mkIf cfg.enable {

    services.tailscale = {
      enable = true;
      disableTaildrop = true;
      disableUpstreamLogging = true;
      authKeyFile = cfg.authKeyFile;
    };

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    systemd.services.tailscaled.serviceConfig.Environment = mkIf config.networking.nftables.enable [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    systemd.services.tailscale-set-ip = mkIf (cfg.ipv4 != "" && cfg.apiKeyFile != null) {
      after = [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
        "tailscale-set.service"
      ];
      wants = [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      path = [
        pkgs.jq
        pkgs.curl
        config.services.tailscale.package
      ];

      script = ''
        until tailscale status --json >/dev/null 2>&1; do
          sleep 0.5
        done

        getTailscaleIP() {
          tailscale status --json | jq -r '.Self.TailscaleIPs[0]'
        }

        getDeviceID() {
          tailscale status --json | jq -r '.Self.ID'
        }

        if [[ $(getTailscaleIP) != ${cfg.ipv4} ]]; then
          echo "IP is not set. Updating IP via API..."
          curl -f "https://api.tailscale.com/api/v2/device/$(getDeviceID)/ip" \
            --request POST \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer $(cat ${cfg.apiKeyFile})" \
            --data '{
            "ipv4": "${cfg.ipv4}"
          }'
        else
          echo "IP is already set. Doing nothing."
        fi
      '';

    };

  };
}
