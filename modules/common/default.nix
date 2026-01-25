{ config, pkgs, lib, paths, ... }:

{
  imports = [
    (paths.common + "/users.nix")
    (paths.common + "/networking.nix")
  ];


  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  services.openssh.enable = true;
  services.openssh.ports = [ 2009 ];
  networking.firewall.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
