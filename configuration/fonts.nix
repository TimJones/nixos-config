{ pkgs
, ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs.nerd-fonts; [
      meslo-lg
      caskaydia-mono
      droid-sans-mono
      hack
    ];

    fontconfig.defaultFonts = {
      monospace = [ "MesloLGM Nerd Font" ]; # LG=Line Gap - Small, Medium, or Large
    };
  };
}
