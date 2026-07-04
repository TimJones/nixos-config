{ den, ... }:
{
  den.aspects.network = {
    nixos = {
      networking.networkmanager.enable = true;
    };

    permSys.directories = [ "/var/lib/NetworkManager" ];
  };
}
