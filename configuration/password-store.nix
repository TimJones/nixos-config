{
  home-manager.users.tim.programs.password-store.enable = true;

  environment.persistence."/persist".users.tim.directories = [
    ".local/share/password-store"
  ];
}
