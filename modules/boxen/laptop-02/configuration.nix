{ den, ... }:
{
  den.aspects.laptop-02 = {
    includes = [
      den.aspects.host-secrets
      den.aspects.impermanence
    ];

    nixos = { pkgs, ... }: {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      services.automatic-timezoned.enable = true;

      # Add the firmware ectool and allow 'wheel' members to run it
      environment.systemPackages = [ pkgs.fw-ectool ];
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.policykit.exec"
              && action.lookup("program").endsWith("/ectool")
              && subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };
}
