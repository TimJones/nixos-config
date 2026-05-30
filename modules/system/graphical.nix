{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-graphical = {
    imports = with inputs.self.modules.nixos; [
      system-terminal
      pipewire
      regreet
    ];
  };
}
