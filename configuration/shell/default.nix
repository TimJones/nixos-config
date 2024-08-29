{ config
, lib
, pkgs
, ...
}: let
    xdir = config.home-manager.users.tim.xdg;
  in
{
  programs.zsh.enable = true;

  home-manager.users.tim = {
    programs = {
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

        initExtraFirst = ''
          # Powerlevel10k instant prompt
          if [[ -r "$${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$${(%):-%n}.zsh" ]]; then
            source "$${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$${(%):-%n}.zsh"
          fi
        '';

        initExtra = ''
          # Powerlevel10k theme
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ${xdir.configFile."p10k/config.zsh".target}
        '';
      };
    };

    xdg = {
      enable = true;
      configFile."p10k/config.zsh".source = ./p10k.zsh;
    };
  };

  environment.persistence."/persist".users.tim = {
    files = [
      ".zsh_history"
      ".cache/p10k-instant-prompt-tim.zsh"
    ];
    directories = [
      ".local/share/direnv"
    ];
  };
}
