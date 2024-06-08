{ config
, pkgs
, ...
}: {
  imports = [
    ./waybar.nix
    ./wofi.nix
    ./kitty.nix
  ];

  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [
    wluma          # Auto screen brightness
    udiskie        # Disk mount helper
    hyprpaper      # Wallpaper
    playerctl      # MPRIS client
    brightnessctl  # Manual screen brightness
  ];

  home-manager.users.tim.xdg = {
    enable = true;
    dataFile."wallpaper.png".source = ./nix-wallpaper-mosaic-blue.png;
    configFile."hypr/hyprpaper.conf".text = ''
      ipc = off
      preload = ${config.home-manager.users.tim.xdg.dataHome}/wallpaper.png 
      wallpaper = ,${config.home-manager.users.tim.xdg.dataHome}/wallpaper.png
    '';
  };

  programs.hyprland.enable = true;
  home-manager.users.tim.services.dunst.enable = true;
  home-manager.users.tim.wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Global variables
      "$mod" = "SUPER";

      # Laptop screen
      monitor = "eDP-1, highres, auto, 1";

      # General config
      gestures.workspace_swipe = true;
      general.border_size = 2;
      decoration.rounding = 10;
      misc.force_default_wallpaper = 0;

      env = [
        "XCURSOR_SIZE,24"
      ];

      input = {
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      exec-once = [
        "dunst"
        "wluma"
        "waybar"
        "udiskie --tray"
        "nmapplet --indicator"
        "hyprpaper"
        "blueman-applet"
      ];

      bind = [
        "$mod, Q, exit"
        "$mod, C, killactive"
        "$mod, M, fullscreen, 1" # Maximise
        "$mod, F, fullscreen, 0" # Fullscreen

        # App launchers
        "$mod, return, exec, kitty"
        "$mod, R, exec, wofi --show drun"

        # Media keys
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # Move window focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Switch workspaces...
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        # ...by scrolling the mousewheel
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      # Repeating commands
      binde = [
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ];

      bindm = [
        # Move/resize winfows with $mod + LMB/RMB-drag
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
