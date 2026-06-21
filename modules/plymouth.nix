{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      boot = {
        plymouth = {
          enable = true;
          theme = "catppuccin-mocha";
          themePackages = [
            (pkgs.catppuccin-plymouth.override { variant = "mocha"; })
          ];
        };

        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];
      };
  };
}
