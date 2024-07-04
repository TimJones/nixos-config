{
  home-manager.users.tim.programs.kitty = {
    enable = true;

    theme = "Catppuccin-Mocha";

    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
