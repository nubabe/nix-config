{ inputs, ... }:

{

  flake.modules.generic.home-manager =
    { config, lib, ... }:

    let
      inherit (lib)
        mkOption
        mkEnableOption
        mkIf
        types
        map
        ;
      cfg = config.nubabe.home-manager;

      user = config.nubabe.users.username;
    in

    {

      options.nubabe.home-manager = {
        enable = mkEnableOption "nubabe home-manager configuration";
        modules = mkOption {
          type = types.listOf types.deferredModule;
          default = [ ];
          description = "Modules to load into home-manager";
        };
      };

      config = mkIf cfg.enable {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${user} = {
            imports = [ inputs.self.homeModules.default ] ++ cfg.modules;
            home.stateVersion = config.system.stateVersion;
          };
        };
      };

    };

}
