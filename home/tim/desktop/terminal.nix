{
  programs.zsh = {
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

  programs.kitty = {
    enable = true;

    theme = "Tokyo Night Storm";

    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}

