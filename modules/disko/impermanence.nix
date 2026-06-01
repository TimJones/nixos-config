{
  inputs,
  ...
}:
{
  flake.modules.nixos.disko =
    { config, ... }:
    {
      fileSystems = inputs.self.lib.mkIfPersistence config {
        "/persist".neededForBoot = true;
        "/home".neededForBoot = true;
      };

      boot.initrd.systemd.services.impermanence = inputs.self.lib.mkIfPersistence config {
        description = "Restore the clean snapshots and keep old snapshots available for 30 days";
        wantedBy = ["initrd.target"];
        before = ["sysroot.mount"];
        serviceConfig.Type = "oneshot";
        script = builtins.readFile ./clean-disk.sh;
      };
    };
}
