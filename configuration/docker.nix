{ pkgs
, ...
}: {
  users.users.tim.extraGroups = [ "docker" ];
  virtualisation.docker = {
    enable = true;
    extraPackages = with pkgs; [
      docker-buildx
    ];
  };
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/docker"
    ];
  };
}
