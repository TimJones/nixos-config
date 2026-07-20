{ den, ... }:
{
  den.aspects.tim.provides.steam = {
    includes = [ den.aspects.steam ];

    permHome.directories = [
      ".local/share/Steam"
      ".steam"
      ".factorio"
    ];
  };
}
