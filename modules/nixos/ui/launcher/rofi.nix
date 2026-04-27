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
      prefix = osConfig.nubabe.ui.wm.uwsm.wrapper.command;
      prefix' = if prefix != "" then "${prefix} " else "";
    in
    {

      config.programs.rofi = {
        enable = true;
        terminal = osConfig.nubabe.ui.terminal.default;
        extraConfig = {
          run-command = "${prefix'}{cmd}";
          run-shell-command = "${prefix'}{terminal} -e {cmd}";
        };
      };

    };

}
