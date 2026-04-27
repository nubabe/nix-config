{ ... }:

{

  flake.modules.nixos.stylix =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.ui.stylix;
    in

    {
      options.nubabe.ui.stylix.enable = mkEnableOption "nubabe stylix configuration";

      config = mkIf cfg.enable {
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
          polarity = "dark";
          fonts = {
            monospace = {
              package = pkgs.nerd-fonts.caskaydia-cove;
              name = "CaskaydiaCove Nerd Font";
            };
            serif = config.stylix.fonts.monospace;
            sansSerif = config.stylix.fonts.monospace;
            emoji = {
              package = pkgs.whatsapp-emoji-font;
              name = "Apple Color Emoji";
            };
          };
        };
      };
    };

}
