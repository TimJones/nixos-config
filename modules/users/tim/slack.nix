{ den, ... }:
{
  den.aspects.tim.provides.slack = {
    includes = [ (den.batteries.unfree [ "slack" ]) ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ slack ];
      };

    permHome.directories = [ ".config/Slack" ];
  };
}
