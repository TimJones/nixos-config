{
  inputs,
  ...
}:
{
  flake.modules.nixos."test-vm" = {
    imports = with inputs.self.modules.nixos; [
      test
    ];
  };
}
