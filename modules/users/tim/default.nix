{ den, ... }:
{
  den.aspects.tim = {
    includes = [
      den.batteries.primary-user
      den.batteries.tpm-access
      (den.batteries.user-shell "zsh")
      den.aspects.tim.ssh
      den.aspects.host-secrets
    ];

    permHome = {
      directories = [
        "projects"
      ];
    };

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
