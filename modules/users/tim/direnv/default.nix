{ den, ... }:
{
  den.aspects.tim.provides.direnv = {
    includes = [ den.aspects.direnv ];

    homeManager = {
      programs.direnv = {
        stdlib = builtins.readFile ./stdlib.sh;
        enableZshIntegration = true;

        config.whitelist.prefix = [
          "~/projects/personal"
        ];
      };
    };
  };
}
