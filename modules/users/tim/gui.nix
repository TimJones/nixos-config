{ den, ... }:
{
  den.aspects.tim.provides.gui = {
    includes = [
      den.aspects.tim.dms
      den.aspects.tim.firefox
      den.aspects.tim.kitty
      den.aspects.tim.slack
      den.aspects.tim.steam
    ];
  };
}
