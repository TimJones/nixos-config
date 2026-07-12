{ den, ... }:
{
  den.aspects.tim = {
    includes = [
      den.batteries.primary-user
      den.batteries.tpm-access
      den.aspects.tim.zsh
      den.aspects.tim.cli
      den.aspects.tim.gui
      den.aspects.tim.stylix
    ];

    permHome.directories = [ "projects" ];

    nixos = {
      users.mutableUsers = false;

      sops.secrets = {
        "tim/pwd_hash" = {
          sopsFile = ./secrets.yaml;
          neededForUsers = true;
          key = "pwd_hash";
        };
      };
    };

    user =
      { osConfig, ... }:
      {
        hashedPasswordFile = osConfig.sops.secrets."tim/pwd_hash".path;
      };
  };
}
