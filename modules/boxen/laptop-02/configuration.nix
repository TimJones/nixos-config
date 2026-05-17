{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "laptop-02";

  flake.modules.nixos."laptop-02" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        systemd-boot
        tpm-host-secrets
        system-base
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      time.timeZone = "Europe/Madrid";

      system.stateVersion = "25.11";
    };
}
