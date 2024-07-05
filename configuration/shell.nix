{
  programs.zsh.enable = true;

  home-manager.users.tim.programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;

      history.ignoreAllDups = true;

      dirHashes = {
        personal = "~/projects/personal";
        work = "~/projects/siderolabs";
      };
    };
  };

  environment.persistence."/persist".users.tim = {
    files = [
      ".zsh_history"
    ];
    directories = [
      ".local/share/direnv"
    ];
  };
}
