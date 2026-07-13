{
  den.aspects.docker = {
    nixos =
      { pkgs, ... }:
      {
        virtualisation.docker = {
          enable = true;
          storageDriver = "btrfs";
          autoPrune.enable = true;
          extraPackages = [ pkgs.docker-buildx ];
        };
      };

    permSys.directories = [ "/var/lib/docker" ];
  };
}
