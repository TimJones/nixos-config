{ pkgs
, ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" "CascadiaCode" "DroidSansMono" "Hack" ]; })
    ];

    fontconfig.defaultFonts = {
      monospace = [ "MesloLGM Nerd Font" ]; # LG=Line Gap - Small, Medium, or Large
    };
  };
}
