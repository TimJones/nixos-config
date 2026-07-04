{ den, ... }:
{
  den.aspects.tim.provides.ssh = {
    includes = [ den.aspects.host-secrets ];

    # As this key is esentially the users' SOPS key, it needs to be unlocked at the host level
    nixos =
      { config, ... }:
      let
        userCfg = config.users.users.tim;
      in
      {
        sops.secrets."${userCfg.name}/ssh/id_ed25519" = {
          sopsFile = ./secrets.yaml;
          key = "ssh/ed25519";
          path = "${userCfg.home}/.ssh/id_ed25519";
          owner = userCfg.name;
          mode = "0400";
        };
      };

    user = {
      openssh.authorizedKeys.keyFiles = [ ./id_ed25519.pub ];
    };
  };
}
