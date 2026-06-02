{
  flake.modules.homeManager.tim = {
    programs.zsh = {
      autocd = true;

      history = {
        append = true;
        saveNoDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
      };

      historySubstringSearch.enable = true;
    };
  };
}
