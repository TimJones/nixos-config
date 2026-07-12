{ den, ... }:
{
  den.aspects.tim.provides.gui = {
    includes = [
      den.aspects.tim.dms
      den.aspects.tim.firefox
      den.aspects.tim.kitty
    ];
  };
}
