{ den, ... }:
{
  den.aspects.tim = {
    includes = [ den.aspects.sops-nix ];

    nixos = { config, ... }: {
      users.mutableUsers = false;

      sops.secrets = {
        "tim/pwd_hash" = {
          sopsFile = ./secrets.yaml;
          neededForUsers = true;
          key = "pwd_hash";
        };
        "tim/ssh/id_ed25519" = {
          sopsFile = ./secrets.yaml;
          key = "ssh/ed25519";
          owner = config.users.users.tim.name;
        };
      };
    };

    user = { osConfig, ... }: {
      hashedPasswordFile = osConfig.sops.secrets."tim/pwd_hash".path;
    };
  };
}
