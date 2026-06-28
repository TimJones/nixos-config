{ den, ... }:
{
  den.aspects.tim = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
