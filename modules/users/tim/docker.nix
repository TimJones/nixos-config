{
  den.aspects.tim.provides.docker = {
    user =
      { osConfig, lib, ... }:
      {
        extraGroups = lib.optional osConfig.virtualisation.docker.enable "docker";
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          docker-credential-helpers
          crane
        ];

        programs.docker-cli = {
          enable = true;
          settings = {
            "credsStore" = "pass";
            "auths" = {
              "ghcr.io" = { };
            };
          };
        };
      };
  };
}
