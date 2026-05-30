{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "25.11" "test-vm";

  flake.modules.nixos."test-vm" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-terminal
        systemd-boot
        tpm-host-secrets
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      time.timeZone = "Europe/Madrid";
    };
}
