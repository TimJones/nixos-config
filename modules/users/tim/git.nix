{ den, ... }:
{
  den.aspects.tim.provides.git = {
    includes = [ den.aspects.git ];

    homeManager = {
      programs.git = {
        settings.user = {
          name = "Tim Jones";
          email = "timniverse@gmail.com";
        };
      };
    };
  };
}
