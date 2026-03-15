{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-graphical = {
    imports = with inputs.self.modules.nixos; [
      system-base
    ];
  };
}
