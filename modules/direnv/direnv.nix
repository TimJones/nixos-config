{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      stdlib = builtins.readFile ./stdlib.sh;
    };
  };
}
