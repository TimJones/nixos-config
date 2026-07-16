{
  den.aspects.bluetooth = {
    nixos = {
      hardware.bluetooth.enable = true;
    };

    provides.to-users = {
      homeManager = {
        services.mpris-proxy.enable = true;
      };
    };

    permSys.directories = [ "/var/lib/bluetooth" ];
  };
}
