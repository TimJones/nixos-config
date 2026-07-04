{ den, ... }:
{
  den.aspects.tim.provides.cli = {
    includes = [
      den.aspects.tim.ssh
      den.aspects.tim.git
    ];
  };
}
