{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "test-vm";

  flake.modules.nixos."test-vm" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        systemd-boot
        tpmHostSecrets
        system-graphical
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      time.timeZone = "Europe/Madrid";

      system.stateVersion = "25.11";
    };
}
