{
  wayland.windowManager.hyprland = {
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
        "waybar"
      ];

      bind = [
        "$mod, Q, exit"
        "$mod, C, killactive"
        "$mod, M, fullscreen, 1" # Maximise
        "$mod, F, fullscreen, 0" # Fullscreen

        # App launchers
        "$mod, return, exec, kitty"
        "$mod, R, exec, wofi --show drun"

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

      bindm = [
        # Move/resize winfows with $mod + LMB/RMB-drag
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.wofi = {
    enable = true;

    style = ''
      *{
          font-family: monospace;
      }
      
      window {
          margin: 5px;
          border: 0px solid white;
          background-color: rgba(48, 98, 148, 1.0);
      }
      
      #input {
          margin: 5px;
          border-radius: 0px;
          border: none;
          border-bottom: 0px solid black;
          background-color: #1A1C1E;
          color: white;
      }
      
      #inner-box {
          margin: 5px;
          background-color: #1A1C1E;
      }
      
      #outer-box {
          margin: 5px;
          padding:20px;
          background-color: #1A1C1E;
      }
      
      #scroll {
      }
      
      #text {
          margin: 5px;
          color: white;
      }
      
      #entry:selected {
          background-color: #151718;
      }
      
      #text:selected {
          text-decoration-color: white;
      }
    '';
  };

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        modules-left = [ "cpu" "memory" "temperature" "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ ];
        modules-right = [ "tray" "network" "backlight" "battery" "clock" "group/power" ];

        cpu = {
          interval = 5;
          format = " {usage}% ({load})";
          on-click = "kitty -e 'top -o %CPU'";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        memory = {
          interval = 5;
          format = " {}%";
          on-click = "kitty -e 'top -o %MEM'";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        temperature = {
          format = " {temperatureC}°C";
        };

        backlight = {
          interval = 5;
          format = "{percent}% {icon}";
          format-icons = [ "󱩎" "󱩑" "󱩔" "󰛨" ];
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) {icon}";
          format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
        };

        battery = {
          interval = 60;
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        "group/power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            children-class = "not-power";
            transition-left-to-right = false;
          };
          modules = [ "custom/power" "custom/quit" "custom/lock" "custom/reboot" ];
        };
        "custom/quit" = {
          format = "󰗼";
          tooltip = false;
          on-click = "hyprctl dispatch exit";
        };
        "custom/lock" = {
          format = "󰍁";
          tooltip = false;
          on-click = "swaylock";
        };
        "custom/reboot" = {
          format = "󰜉";
          tooltip = false;
          on-click = "systemctl reboot";
        };
        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "systemctl poweroff";
        };
      };
    };

    style = ''
      @define-color base           #1e242f;
      @define-color urgent         #b02c36;
      @define-color primary_orange #fe9000;
      @define-color primary_yellow #ffdd4a;
      @define-color primary_red    #da1b2b;
      @define-color primary_blue   #afd2e9;
      @define-color primary_blue_2 #6fadd6;
      
      @keyframes blink-warning {
          70% {
              color: white;
          }
      
          to {
              color: white;
              background-color: orange;
          }
      }
      
      @keyframes blink-critical {
          70% {
            color: white;
          }
      
          to {
              color: white;
              background-color: red;
          }
      }
      
      /* Reset all styles */
      * {
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 1px;
          padding: 0;
      }
      
      /* The main bar */
      #waybar {
          background: transparent;
          color: @primary_blue;
          background-color: @base;
          font-family: monospace;
          font-size: 16px;
          border-radius: 15px;
      }
      
      /* Modules */
      #battery,
      #clock,
      #backlight,
      #cpu,
      #memory,
      #network,
      #temperature,
      #tray,
      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power {
          padding:0.5rem 0.6rem;
          margin: 1px 0px;
      }
      
      #battery {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      
      #battery.warning {
          color: @primary_orange;
      }
      
      #battery.critical {
          color: @primary_red;
      }
      
      #battery.warning.discharging {
          animation-name: blink-warning;
          animation-duration: 3s;
      }
      
      #battery.critical.discharging {
          animation-name: blink-critical;
          animation-duration: 2s;
      }
      
      #cpu.warning {
          color: @primary_orange;
      }
      
      #cpu.critical {
          color: @primary_red;
      }
      
      #memory {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      
      #memory.warning {
          color: @primary_orange;
      }
      
      #memory.critical {
          color: red;
          animation-name: blink-critical;
          animation-duration: 2s;
          padding-left:5px;
          padding-right:5px;
      }
      
      #network.disconnected {
          color: @primary_orange;
      }
      
      #temperature.critical {
          color: red;
      }
      
      #window {
          font-weight: bold;
      }
      
      #workspaces {
          font-size:14px;
      }
      
      #workspaces button {
          border-bottom: 3px solid @primary_blue_2;
          margin-bottom: 0px;
          padding:0px;
      }
      
      #workspaces button.focused {
          border-bottom: 3px solid  @primary_yellow;
          margin-bottom: 0px;
          padding-left:0;
      }
      
      #workspaces button.urgent {
          border-color: @primary_red;
          color: @primary_red;
      }
      
      #.icon {
          font-size: 16px;
      }
    '';
  };

  services.dunst.enable = true;
}
