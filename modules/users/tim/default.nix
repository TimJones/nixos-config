{ den, ... }:
{
  den.aspects.tim = {
    includes = [
      den.batteries.primary-user
      den.batteries.tpm-access
      (den.batteries.user-shell "zsh")
    ];
  };
}
