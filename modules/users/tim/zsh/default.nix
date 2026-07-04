{ den, ... }:
{
  den.aspects.tim.provides.zsh = {
    includes = [
      (den.batteries.user-shell "zsh")
    ];

    homeManager = { pkgs, ... }: {
      # Technically not *part* of zsh, but meh
      programs.fzf.enableZshIntegration = true;

      programs.zsh = {
        autocd = true;
        enableCompletion = true;
        enableVteIntegration = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

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

    permHome = {
      files = [
        ".zsh_history"
      ];
    };
  };
}
