{ den, ... }:
{
  den.aspects.tim.provides.cli = {
    includes = [
      den.aspects.tim.ssh
      den.aspects.tim.git
      den.aspects.tim.direnv
      den.aspects.tim.nixvim
      den.aspects.tim.gpg
      den.aspects.tim.password-store
      den.aspects.tim.docker
    ];
  };
}
