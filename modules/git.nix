{
  flake.modules.homeManager.git =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        tig
      ];
      programs = {
        gh.enable = true;
        git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
            pull.ff = "only";
            push = {
              default = "current";
              autoSetupRemote = true;
            };
            url = {
              "ssh://git@github.com" = {
                insteadOf = "https://github.com";
              };
            };
          };
        };
      };
    };
}
