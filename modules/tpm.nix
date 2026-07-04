{
  den.aspects.tpm = {
    nixos =
      { pkgs, ... }:
      {
        security.tpm2 = {
          enable = true;
          pkcs11.enable = true;
          tctiEnvironment.enable = true;
        };

        environment.systemPackages = with pkgs; [
          tpm2-tss
          tpm2-tools
        ];
      };
  };

  den.batteries.tpm-access =
    { user, ... }:
    {
      name = "tpm-access(${user.userName})";
      nixos =
        { config, lib, ... }:
        {
          users.users.${user.userName}.extraGroups = lib.optional config.security.tpm2.enable "tss";
        };
    };
}
