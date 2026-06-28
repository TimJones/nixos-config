{
  den.aspects.powercable = {
    nixos =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        # udev requires an absolute path in RUN+=
        ppctl = lib.getExe' config.services.power-profiles-daemon.package "powerprofilesctl";
      in
      {
        systemd.services.powercable-startup = {
          description = "Set power profile from mains state at startup";
          wantedBy = [ "multi-user.target" ];
          after = [ "power-profiles-daemon.service" ];
          wants = [ "power-profiles-daemon.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "powercable-startup" ''
              online=0
              for supply in /sys/class/power_supply/*; do
                if [ "$(cat "$supply/type" 2>/dev/null)" = "Mains" ] \
                  && [ "$(cat "$supply/online" 2>/dev/null)" = "1" ]; then
                  online=1
                  break
                fi
              done
              if [ "$online" = "1" ]; then
                ${ppctl} set performance
              else
                ${ppctl} set power-saver
              fi
            '';
          };
        };

        services.udev.packages = lib.singleton (
          pkgs.writeTextFile {
            name = "powercable-udev-rules";
            text = ''
              # Allow (un)plugging of the mains cable to switch the power profile
              SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${ppctl} set performance"
              SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${ppctl} set power-saver"
            '';
            destination = "/etc/udev/rules.d/95-powercable.rules";
          }
        );

        security.polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.UPower.PowerProfiles.switch-profile"
                && subject.user == "root") {
              return polkit.Result.YES;
            }
          });
        '';
      };
  };
}
