{ inputs, ... }:

let
  hmModules = inputs.self.modules.homeManager;
in

{

  flake.homeModules = {

    core = {
      imports = with hmModules; [
        shell
        coreTools
      ];
    };

    graphical = {
      imports = with hmModules; [
        browser
      ];
    };

  };

}
