{
  inputs,
  ...
}:
{
  flake.modules.nixos."laptop-02" = {
    imports = with inputs.self.modules.nixos; [
      tim
    ];
  };
}
