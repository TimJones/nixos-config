{
  self,
  lib,
  ...
}:
{
  config.flake.factory.user =
    {
      username,
      isAdmin ? false,
      hasSSH ? false,
      hasPwdHash ? false,
    }:
    {
      nixos.ssh = lib.mkIf hasSSH {
        programs.ssh.extraConfig = ''
          IdentityFile /run/secrets/%u/ssh/id_ed25519
        '';
      };

      nixos."${username}" =
        { config, ... }:
        {
          sops.secrets = {
            "${username}/pwd_hash" = lib.mkIf hasPwdHash {
              sopsFile = ./${username}/secrets.yaml;
              neededForUsers = true;
              key = "pwd_hash";
            };

            "${username}/ssh/id_ed25519" = lib.mkIf hasSSH {
              sopsFile = ./${username}/secrets.yaml;
              key = "ssh/ed25519";
              owner = config.users.users."${username}".name;
            };
          };

          users = {
            mutableUsers = lib.mkIf hasPwdHash false;

            users."${username}" = {
              isNormalUser = true;
              home = "/home/${username}";
              hashedPasswordFile = lib.mkIf hasPwdHash config.sops.secrets."${username}/pwd_hash".path;

              extraGroups = lib.optionals isAdmin [
                "wheel"
                "tss"
              ];

              openssh.authorizedKeys.keyFiles = lib.optionals hasSSH [
                ./${username}/id_ed25519.pub
              ];
            };
          };

          home-manager.users."${username}".imports = [
            self.modules.homeManager."${username}"
          ];
        };
    };
}
