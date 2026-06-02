{
  inputs,
  ...
}:
{
  flake.modules.nixos.zsh = {
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];
  };

  flake.modules.homeManager.zsh =
    { config, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
      };

      home.persistence."/persist" = inputs.self.lib.mkIfPersistence config {
        files = [
          ".zsh_history"
        ];
      };
    };
}
