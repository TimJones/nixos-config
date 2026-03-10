{
  inputs,
  ...
}:
{
  flake.modules.nixos."test-vm" =
    { config, ... }:
    {
      imports = with inputs.self.factory; [
        (diskoMainDevice {
          inherit config;
          mainDevice = "/dev/vda";
          encrypt = true;
        })
      ];
    };
}
