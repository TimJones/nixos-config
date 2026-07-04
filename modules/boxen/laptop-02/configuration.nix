{ den, ... }:
{
  den.aspects.laptop-02 = {
    includes = [
      den.aspects.host-secrets
      den.aspects.impermanence
      den.aspects.ssh
      den.aspects.wifi
      den.aspects.hyprland
    ];

    nixos = { pkgs, ... }: {
      boot.kernelPackages = pkgs.linuxPackages_latest;

      time.timeZone = "Europe/Madrid";

      networking.interfaces.wlp1s0.useDHCP = true;
    };
  };
}
