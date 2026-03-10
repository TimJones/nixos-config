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

      boot.initrd.postResumeCommands =
        inputs.self.lib.mkIfPersistence config (builtins.readFile ./clean-disk.sh);
    };
}
