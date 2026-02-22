{
  flake.modules.nixos.tpm =
    { pkgs, ... }:
    {
      security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
      };

      environment.systemPackages = with pkgs; [
        tpm2-tools
        tpm2-tss
      ];
    };
}
