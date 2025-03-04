{ pkgs
, ...
}: {
  home-manager.users.tim = {
    home.packages = with pkgs; [
      tig
    ];

    programs.git = {
      enable = true;

      userName = "Tim Jones";
      userEmail = "timniverse@gmail.com";

      extraConfig = {
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

      includes = [{
        condition = "gitdir:~/projects/siderolabs/";
        contents = {
          tag.gpgSign = true;
          commit.gpgSign = true;
          format.signOff = true;
          user = {
            email = "tim.jones@siderolabs.com";
            signingKey = "5D7964FF2DB426ACB3C3505AA2A702DD5B689F45";
          };
        };
      }];
    };

    programs.gh.enable = true;
  };
}
