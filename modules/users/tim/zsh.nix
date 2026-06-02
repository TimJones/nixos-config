{
  flake.modules.homeManager.tim =
  { pkgs, ... }:
  {
    programs.zsh = {
      autocd = true;

      history = {
        append = true;
        saveNoDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
      };

      historySubstringSearch.enable = true;

      initContent = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./p10k.zsh}
      '';
    };
  };
}
