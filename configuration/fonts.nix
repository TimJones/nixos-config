{ pkgs
, ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" "DroidSansMono" "Hack" ]; })
    ];

    fontconfig.defaultFonts = {
      monospace = [ "CaskaydiaCove Nerd Font Mono" ];
    };
  };
}
