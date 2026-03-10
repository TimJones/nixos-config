{
  inputs,
  ...
}:
{
  flake.modules.nixos.disko =
    { config, ... }:
    {
      fileSystems."/persist".neededForBoot = inputs.self.lib.mkIfPersistence config true;

      boot.initrd.postDeviceCommands =
        inputs.self.lib.mkIfPersistence config builtins.readFile
          ./clean-disk.sh;
    };
}
