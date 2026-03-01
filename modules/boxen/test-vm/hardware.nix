{
  inputs,
  ...
}:
{
  flake.modules.nixos."test-vm" = {
    imports = with inputs.self.factory; [
      (diskoMainDevice {
        mainDevice = "/dev/vda";
        encrypt = true;
      })
    ];
  };
}
