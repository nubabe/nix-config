{ inputs, ... }:

{

  flake.modules.nixos.terminal =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf optional;
      cfg = config.nubabe.graphical.terminal.alacritty;
    in

    {
      options.nubabe.graphical.terminal.alacritty.enable =
        mkEnableOption "nubabe alacritty configuration";

      config = mkIf cfg.enable {
        nubabe.home-manager.modules.user = [ inputs.self.modules.homeManager.alacritty ];
      };
    };

  flake.modules.homeManager.alacritty = {

    programs.alacritty = {
      enable = true;
      settings = {
        hints.enabled = [
          {
            command = "xdg-open";
            hyperlinks = true;
            post_processing = true;
            persist = false;
            mouse.enabled = true;
            binding = {
              key = "O";
              mods = "Control|Shift";
            };
            regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`\\\\]+'';
          }
        ];
      };
    };

  };

}
