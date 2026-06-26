{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-graphical = {
    imports = with inputs.self.modules.nixos; [
      system-terminal
      plymouth
      pipewire
      regreet
      hyprland
    ];
  };

  flake.modules.homeManager.system-graphical = {
    imports = with inputs.self.modules.homeManager; [
      system-terminal
      hyprland
      kitty
      firefox
    ];
  };
}
