{ inputs, ... }:

{

  flake.modules.nixos.keepassxc =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.nubabe.ui.keepassxc;
    in
    {
      options.nubabe.ui.keepassxc.enable = mkEnableOption "nubabe keepassxc config";
      config = mkIf cfg.enable {
        nubabe.home-manager.modules.user = [
          inputs.self.modules.homeManager.keepassxc
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
