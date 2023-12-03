{
  pkgs,
  ...
}: {
  # a desktop environment based around Hyprland

  security.rtkit.enable = true;
  networking.networkmanager.enable = true;
  users.users.tim.extraGroups = [ "networkmanager" "video" ];
  # sound.mediaKeys.enable = true;

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
	support32Bit = true;
      };
     };
     blueman.enable = true;
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
  };

  programs = {
    light.enable = true;
    waybar.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.wofi
    pkgs.firefox-wayland
    pkgs.kitty
    pkgs.swaynotificationcenter
    pkgs.swayosd
    pkgs.udiskie
    pkgs.qt5.qtwayland
    pkgs.qt6.qtwayland
    # pkgs.networkmanager_dmenu
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];
}
