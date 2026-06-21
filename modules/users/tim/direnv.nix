{
  flake.modules.homeManager.tim = {
    programs.direnv = {
      enableZshIntegration = true;
      config = {
        whitelist = {
          prefix = [
            "~/projects/personal"
          ];
        };
      };
    };
  };
}
