{
  config.flake.factory.user =
    {
      username,
      isAdmin ? false,
      hasSSH ? false,
    }:
    {
      nixos."${username}" =
        { lib, ... }:
        {
          users.users."${username}" = {
            isNormalUser = true;
            home = "/home/${username}";
            extraGroups = lib.optionals isAdmin [
              "wheel"
            ];
            openssh.authorizedKeys.keyFiles = lib.optionals hasSSH [
              ./${username}/id_ed25519.pub
            ];
          };
        };
    };
}
