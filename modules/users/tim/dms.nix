{ inputs, den, ... }:
{
  den.aspects.tim.provides.dms = {
    includes = [ den.aspects.tim.hyprland ];

    homeManager = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms-plugin-registry.homeModules.default
      ];

      # Silence the "What's New" window on startup.
      # TODO: bump this every time DMS gets updated :/
      xdg.configFile."DankMaterialShell/.changelog-1.5".text = "";

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;

        managePluginSettings = true;
        plugins = {
          dmsFrameworkBattery.enable = true;
        };

        settings = {
          # Workspace
          showWorkspaceApps = true;
          showWorkspaceIndex = true;
          workspaceFollowFocus = true;
          workspaceOccupiedColorMode = "s";
          showOccupiedWorkspacesOnly = true;

          # Notification
          notificationShowTimeoutBar = true;
          notificationFocusedMonitor = true;
          lockScreenNotificationMode = 2; # Show apps & count

          # Task bar
          updaterHideWidget = true;
          launcherLogoMode = "os";
          showClipboard = false;

          # OSD
          osdAlwaysShowValue = true;
          osdPowerProfileEnabled = true;
          osdPosition = 4; # Middle top

          # Weather
          useAutoLocation = true;

          screenPreferences.wallpaper = [ ];

          dashTabs = [
            {
              id = "overview";
              enabled = true;
            }
            {
              id = "media";
              enabled = true;
            }
            {
              id = "wallpaper";
              enabled = false;
            }
            {
              id = "weather";
              enabled = true;
            }
            {
              id = "settings";
              enabled = true;
            }
          ];

          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = 0; # Top
              screenPreferences = [ "all" ];
              showOnLastDisplay = true;
              hoverPopouts = true;
              leftWidgets = [
                "launcherButton"
                "workspaceSwitcher"
                "focusedWindow"
              ];
              centerWidgets = [
                "music"
                "clock"
                "weather"
              ];
              rightWidgets = [
                "systemTray"
                "cpuUsage"
                "memUsage"
                {
                  id = "dmsFrameworkBattery";
                  enabled = true;
                }
                "notificationButton"
                "controlCenterButton"
              ];
            }
          ];
        };
      };
    };
  };
}
