{ den, ... }:
{
  den.aspects.tpm =
    { pkgs, ... }:
    {
      security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
      };

      environment.systemPackage = with pkgs; [
        tpm2-tss
        tpm2-tools
      ];
    };
}
