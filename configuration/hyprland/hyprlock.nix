{
  security.pam.services.hyprlock = {};

  home-manager.users.tim.programs.hyprlock = {
    enable = true;
    settings = {
      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
        ];
      };
      input-field = {
        monitor = "";
        fade_on_empty = false;
      };
      background = {
        color = "rgb(23, 39, 41)";
      };
      auth = {
        "fingerprint:enabled" = true;
      };
    };
  };
}
