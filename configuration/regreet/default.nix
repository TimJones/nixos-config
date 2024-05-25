{
  programs.regreet = {
    enable = true;
    settings = {
      GTK.application_prefer_dark_theme = true;
      background = {
        path = ./nixos-wallpaper-catppuccin-macchiato.png;
        fit = "Cover";
      };
    };
  };

  # For saving previous user/sessions
  environment.persistence."/persist".files = [
    "/var/cache/regreet/cache.toml"
  ];
}
