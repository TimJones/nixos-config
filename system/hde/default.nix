{
  pkgs,
  ...
}: {
  # a desktop environment based around Hyprland

  #services = {
  #  pipewire.enable = true;
  #  xserver = {
  #    enable = true;
  #    displayManager = {
  #      defaultSession = "hyprland";
  #      sddm = {
  #        enable = true;
  #        enableHidpi = true;
  #        wayland.enable = true;
  #      };
  #    };
  #  };
  #};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = [
    pkgs.firefox-wayland
    pkgs.kitty
  ];
}
