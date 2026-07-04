{
  flake-file.inputs = {
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.dms = {
    nixos = {
      services.displayManager.dms-greeter = {
        enable = true;
        compositor.name = "hyprland";
      };

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      programs.dms-shell = {
        enable = true;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        enableVPN = true;
        enableDynamicTheming = false;
        enableAudioWavelength = false;
        enableCalendarEvents = true;
        enableSystemMonitoring = true;
      };
    };

    permSys.directories = [ "/var/lib/dms-greeter" ];
  };
}
