{ lib, den, ... }:
{
  den.default.nixos.system.stateVersion = "26.05";
  den.default.homeManager.home.stateVersion = "26.05";

  # enable homeManager by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
