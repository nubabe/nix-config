{ inputs, withSystem, ... }:

{

  flake.modules.nixos.uwsm =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical.uwsm;
    in

    {
      options.nubabe.graphical.uwsm = {
        enable = mkEnableOption "nubabe uwsm config";

        package = lib.mkPackageOption pkgs "uwsm" { };

        wrapper.command = lib.mkOption {
          type = lib.types.str;
          default = "${lib.getExe cfg.wrapper.package}";
          example = "uwsm app --";
          description = "Command to wrap apps with to execute with uwsm.";
        };

        wrapper.package = lib.mkPackageOption pkgs [ "unstable" "runapp" ] { };

      };

      config = mkIf cfg.enable {

        # nixpkgs.overlays = [
        #   (final: prev: {
        #     xdg-open = final.writeShellApplication {
        #       name = "xdg-open";
        #       runtimeInputs = [
        #         final.handlr-regex
        #         final.jq
        #         cfg.wrapper.package
        #       ];
        #       text = ''
        #         # MIME=$(handlr mime --json "$@" | jq -r '.[0].mime')
        #         # APP=$(handlr get --json "$MIME" | jq -r '.cmd')
        #         # exec ${cfg.wrapper.command} "$APP" "$@"
        #         exec ${cfg.wrapper.command} handlr open "$@"
        #       '';
        #     };

        #     xdg-utils = prev.xdg-utils.overrideAttrs (prevAttrs: {
        #       postFixup = (prevAttrs.postFixup or "") + ''
        #         cp ${lib.getExe final.xdg-open} $out/bin/xdg-open
        #       '';
        #     });
        #   })
        # ];

        programs.uwsm.package = cfg.package;

        nubabe.home-manager.modules.user = [
          inputs.self.modules.homeManager.uwsm
        ];

      };
    };

  flake.modules.homeManager.uwsm =
    {
      config,
      pkgs,
      osConfig,
      ...
    }:
    let
      cfg = osConfig.nubabe.graphical.uwsm.wrapper;
      xdg-open = pkgs.writeShellApplication {
        name = "xdg-open";
        runtimeInputs = [
          pkgs.handlr-regex
          pkgs.jq
          cfg.package
        ];
        text = ''
          MIME=$(handlr mime --json "$@" | jq -r '.[0].mime')
          APP=$(handlr get --json "$MIME" | jq -r '.cmd | sub("\\s+$"; "")')
          exec ${cfg.command} "$APP" "$@"
          # exec ${cfg.command} handlr open "$@"
        '';
      };
    in
    {

      home.packages = [
        cfg.package
        pkgs.handlr-regex
        xdg-open
      ];

      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    };

}
