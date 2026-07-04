{ den, ... }:
{
  den.aspects.hyprland = {
    includes = [
      den.aspects.regreet
    ];

    nixos = {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };

    homeManager = {
      wayland.windowManager.hyprland = {
        enable = true;
      };
    };
  };
}
