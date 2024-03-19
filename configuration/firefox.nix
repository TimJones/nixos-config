{
  home-manager.users.tim.programs.firefox.enable = true;

  environment.persistence."/persist".users.tim.directories = [ ".mozilla/firefox" ];
}
