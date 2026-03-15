{ inputs, ... }:

{

  flake.modules.generic.home-manager =
    { config, lib, ... }:

    let
      inherit (lib) mkOption mkEnableOption mkIf;
      cfg = config.nubabe.home-manager;

      user = config.nubabe.users.username;
    in

    {

      options.nubabe.home-manager = {
        enable = mkEnableOption "nubabe home-manager configuration";
      };

      config = mkIf cfg.enable {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${user} = {
            imports = [ inputs.self.homeModules.default ];
          };
        };
      };

    };

}
