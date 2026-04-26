{ inputs, ... }:

{

  flake.modules.nixos.graphicalTools =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.graphical.tools;
    in
    {
      options.nubabe.graphical.tools.enable = mkEnableOption "nubabe graphical setup";
      config = mkIf cfg.enable {
        nubabe.home-manager.modules.user = with inputs.self.modules.homeManager; [
          keepassxc
        ];
      };
    };

  flake.modules.homeManager.keepassxc = {
    services.ssh-agent.enable = true;
    programs.keepassxc = {
      enable = true;
      settings = {
        Browser = {
          Enabled = true;
          UpdateBinaryPath = false;
        };
        GUI = {
          ApplicationTheme = "auto";
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
        };
        SSHAgent.Enabled = true;
      };
    };
  };

}
