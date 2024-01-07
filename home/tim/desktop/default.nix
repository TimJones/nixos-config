{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix
    ./terminal.nix
  ];

  services.dunst.enable = true;
  programs.firefox.enable = true;
}
