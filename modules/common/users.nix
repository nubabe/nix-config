{ config, pkgs, ... }:

{
  users.users = {

    nubabe = {
      isNormalUser = true;
      description = "nuyan";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [ ];
    };

  };
}
