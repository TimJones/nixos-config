{ den, ... }:
{
  den.aspects.host-secrets = {
    includes = [
      den.aspects.tpm
      den.aspects.sops-nix
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        hostName = config.networking.hostName;
      in
      {
        sops = {
          defaultSopsFile = ./boxen/${hostName}/secrets.yaml;

          gnupg.sshKeyPaths = [ ];

          age = {
            sshKeyPaths = [ ];
            keyFile = "/run/tpm.age";
            plugins = with pkgs; [
              age-plugin-tpm
            ];
          };

          secrets."${hostName}/machine_id".key = "machine_id";
        };

        boot.initrd.systemd.enable = lib.mkForce true; # Needed for TPM auto-unlock

        system.activationScripts = {
          tpmAgeKey = lib.stringAfter [ "specialfs" ] ''
            install -D --mode 400 ${boxen/${hostName}/tpm.age} /run/tpm.age
          '';

          setupSecrets.deps = [ "tpmAgeKey" ];
          setupSecretsForUsers.deps = [ "tpmAgeKey" ];

          # dbus-broker needs a real machine-id file, not a symlink
          machineId = {
            deps = [ "setupSecrets" ];
            text = ''
              install -D --mode 0444 ${config.sops.secrets."${hostName}/machine_id".path} /etc/machine-id
            '';
          };
        };
      };
  };
}
