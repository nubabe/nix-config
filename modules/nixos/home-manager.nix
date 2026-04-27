{ inputs, ... }:

{

  flake.modules.generic.home-manager =
    {
      config,
      lib,
      inputs',
      ...
    }:

    let
      inherit (lib)
        mkOption
        mkEnableOption
        mkIf
        types
        map
        ;
      cfg = config.nubabe.home-manager;

      user = config.nubabe.system.users.username;

      moduleOption = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
        description = "Modules to load into home-manager.";
      };
    in

    {

      options.nubabe.home-manager = {
        enable = mkEnableOption "nubabe home-manager configuration";
        modules.user = moduleOption;
        modules.root = moduleOption;
        modules.shared = moduleOption;
      };

      config = mkIf cfg.enable {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs'; };
          users.${user} = {
            imports = cfg.modules.shared ++ cfg.modules.user;
            home.stateVersion = config.system.stateVersion;
          };
          users.root = {
            imports = cfg.modules.shared ++ cfg.modules.root;
            home.stateVersion = config.system.stateVersion;
          };
        };
      };

    };

}
