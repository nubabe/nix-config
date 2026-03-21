{ inputs, ... }:

let
  hmModules = inputs.self.modules.homeManager;
in

{

  flake.modules.homeManager = {

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
