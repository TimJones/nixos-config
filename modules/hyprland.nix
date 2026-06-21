{
  inputs,
  ...
}:
{
  flake.modules.nixos.hyprland = {
    services.displayManager.dms-greeter.compositor.name = "hyprland";
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang"; # v0.55 supports both lua & hyprlang. TODO: migrate to lua.
    };
  };
}
