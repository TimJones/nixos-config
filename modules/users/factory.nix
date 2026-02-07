{
  config.flake.factory.user =
    {
      username,
      isAdmin ? false,
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
          };
        };
    };
}
