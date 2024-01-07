{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        modules-left = [ "cpu" "memory" "temperature" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
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
      
      #battery.icon {
          font-size: 26px;
      }
    '';
  };
}
