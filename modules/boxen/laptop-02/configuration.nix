{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "26.05" "laptop-02";

  flake.modules.nixos."laptop-02" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-graphical
        tpm-host-secrets
        wifi-settings
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      time.timeZone = "Europe/Madrid";

      networking.interfaces."wlp1s0" = {
        useDHCP = true;
      };
    };
}
