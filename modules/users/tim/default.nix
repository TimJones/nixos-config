{ den, lib, ... }:
{
  den.aspects.tim =
    { host, ... }:
    {
      includes = [
        den.batteries.primary-user
        den.batteries.tpm-access
        den.aspects.tim.zsh
        den.aspects.tim.ssh
        den.aspects.host-secrets
        den.aspects.tim.git
        den.aspects.tim.direnv
        den.aspects.tim.nixvim
      ]
      ++ lib.optionals host.hasGui [
        den.aspects.tim.hyprland
        den.aspects.tim.firefox
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
