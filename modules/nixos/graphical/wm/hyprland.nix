{ inputs, ... }:

{

  flake.modules.nixos.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) mkEnableOption mkIf mkDefault;
      cfg = config.nubabe.graphical.wm.hyprland;
    in

    {

      disabledModules = [
        "programs/wayland/hyprland.nix"
        "programs/wayland/uwsm.nix"
      ];

      imports = [
        "${inputs.nixpkgs-unstable}/nixos/modules/programs/wayland/hyprland.nix"
        "${inputs.nixpkgs-unstable}/nixos/modules/programs/wayland/uwsm.nix"
      ];

      options.nubabe.graphical.wm.hyprland = {
        enable = mkEnableOption "nubabe hyprland config";
      };

      config = mkIf cfg.enable {

        nubabe = {
          hardware.brightnessctl.enable = true;
          audio.enable = true;
          greetd.enable = true;
          graphical = {
            uwsm = {
              enable = true;
              package = pkgs.unstable.uwsm;
            };
            cursor.enable = true;
            bar.enable = true;
            launcher.enable = true;
            notification.enable = true;
          };
        };

        programs.hyprland = {
          enable = true;
          withUWSM = true;
          package = pkgs.unstable.hyprland;
          portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
        };

        nubabe.home-manager.modules.user = [ inputs.self.modules.homeManager.hyprland ];

      };
    };

  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      lib,
      osConfig,
      ...
    }:
    let
      graphical = osConfig.nubabe.graphical;

      terminal = graphical.terminal.default;
      launcher = graphical.launcher.command;
      notification = graphical.notification.default;
      browser = graphical.browser.default;
      uwsmWrapper = graphical.uwsm.wrapper.command;
    in
    {

      home.sessionVariables.NIXOS_OZONE_WL = "1";

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.enable = false;

        settings = {

          general = {
            border_size = 2;
            gaps_in = 3;
            gaps_out = 5;
            resize_on_border = true;
            hover_icon_on_border = true;
            layout = "master";
          };

          decoration = {
            rounding = 10;
            active_opacity = 1;
            inactive_opacity = 0.9;
            blur = {
              enabled = true;
              size = 8;
              passes = 4;
              xray = true;
            };
            shadow.enabled = false;
          };

          misc = {
            disable_splash_rendering = true;
            middle_click_paste = false;
          };

          input = {
            kb_layout = "us";
            kb_variant = "intl";
            kb_options = "shift:both_capslock,ctrl:nocaps";
            follow_mouse = 2;
            touchpad.natural_scroll = true;
          };

          exec-once = [
            "${uwsmWrapper} ${notification}"
          ];

          device = [
            {
              name = "logitech-mx-keys-mac";
              kb_options = "altwin:swap_lalt_lwin,shift:both_capslock,ctrl:nocaps,lv3:rwin_switch";
              kb_model = "applealu_iso";
            }
            {
              name = "apple-inc.-magic-keyboard-with-numeric-keypad";
              kb_options = "altwin:swap_lalt_lwin,shift:both_capslock,ctrl:nocaps,lv3:rwin_switch";
            }
          ];

          windowrule = [
            "match:title termfilechooser, tag +centerfloat"
            "match:tag centerfloat, float on size (monitor_w/2) (monitor_h/2) move (monitor_w/4) (monitor_h/4)"
          ];

          bindeul = [
            ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
          ];
          bindul = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPlay, exec, playerctl play-pause"
          ];
          bind = [
            "Control_L, SPACE, submap, main"
            "SUPER, o, exec, ${uwsmWrapper} ${launcher}"
            "SUPER, t, exec, ${uwsmWrapper} ${terminal}"
            "SUPER, b, exec, ${uwsmWrapper} ${browser}"
          ];

        };

        submaps =
          let
            workspaces = lib.concatLists (
              lib.genList (
                i:
                let
                  ws = toString (i + 1);
                in
                [
                  ", ${ws}, workspace, ${ws}"
                  "SHIFT, ${ws}, movetoworkspace, ${ws}"
                ]
              ) 9
            );

            repeatedSubmaps = [
              ", c, killactive,"

              ", h, layoutmsg, focusmaster master"
              ", j, layoutmsg, cyclenext"
              ", k, layoutmsg, cycleprev"
              ", l, focusurgentorlast,"
              ", comma, workspace, r-1"
              ", period, workspace, r+1"
              ", m, focusmonitor, +1"

              "SHIFT, h, layoutmsg, swapwithmaster ignoremaster"
              "SHIFT, j, layoutmsg, swapnext"
              "SHIFT, k, layoutmsg, swapprev"
              "SHIFT, comma, movetoworkspace, r-1"
              "SHIFT, period, movetoworkspace, r+1"
              "SHIFT, m, movecurrentworkspacetomonitor, +1"
            ];
          in
          {
            "main, reset".settings = {
              bind = [
                ", SPACE, submap, repeat"
                ", f, submap, fullscreen"
                ", o, exec, ${uwsmWrapper} ${launcher}"
              ]
              ++ repeatedSubmaps
              ++ workspaces;

            };

            repeat.settings = {
              bind = [ ", SPACE, submap, reset" ] ++ repeatedSubmaps;
            };

            fullscreen.settings = {
              bind = [
                ", f, fullscreen, 1"
                ", m, fullscreen, 0"
                ", j, togglefloating,"
              ];
            };

          };

      };
    };

}
