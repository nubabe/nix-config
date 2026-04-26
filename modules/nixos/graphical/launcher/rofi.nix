{ inputs, ... }:

{

  flake.modules.homeManager.rofi =
    {
      config,
      pkgs,
      lib,
      osConfig,
      ...
    }:
    let
      prefix = osConfig.nubabe.graphical.uwsm.wrapper.command;
      prefix' = if prefix != "" then "${prefix} " else "";
    in
    {

      config.programs.rofi = {
        enable = true;
        terminal = osConfig.nubabe.graphical.terminal.default;
        extraConfig = {
          run-command = "${prefix'}{cmd}";
          run-shell-command = "${prefix'}{terminal} -e {cmd}";
        };
      };

    };

}
