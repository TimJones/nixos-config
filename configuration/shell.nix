{
  programs.zsh.enable = true;

  environment.persistence."/persist".users.tim.files = [
    ".zsh_history"
  ];

  home-manager.users.tim.programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableVteIntegration = true;
    enableAutosuggestions = true;

    history.ignoreAllDups = true;

    dirHashes = {
      personal = "~/projects/personal";
      work = "~/projects/siderolabs";
    };
  };
}  
