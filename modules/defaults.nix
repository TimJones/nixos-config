{ lib, den, ... }:
{
  # enable homeManager by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default = {
    # Set networking.hostName from den.hosts.<name>
    includes = [ den.batteries.hostname ];

    nixos = {
      system.stateVersion = "26.05";
      boot.loader.systemd-boot.enable = true;
      home-manager.backupFileExtension = "hm-bak";
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    homeManager.home.stateVersion = "26.05";
  };
}
