{
  flake.modules.homeManager.tim = {
    programs.git = {
      settings.user = {
        name = "Tim Jones";
        email = "timniverse@gmail.com";
      };

      includes = [
        {
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
        }
      ];
    };
  };
}
