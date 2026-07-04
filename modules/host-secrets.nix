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
        hostSopsFile = boxen/${hostName}/secrets.yaml;
      in
      {
        boot.initrd.systemd.enable = lib.mkForce true; # Needed for TPM auto-unlock

        system.activationScripts = {
          tpmAgeKey = lib.stringAfter [ "specialfs" ] ''
            install -D -m 600 ${boxen/${hostName}/tpm.age} /run/tpm.age
          '';
          setupSecretsForUsers.deps = [ "tpmAgeKey" ];
        };

        sops = {
          gnupg.sshKeyPaths = [ ];

          age = {
            sshKeyPaths = [ ];
            keyFile = "/run/tpm.age";
            plugins = with pkgs; [
              age-plugin-tpm
            ];
          };

          secrets = {
            "${hostName}/machine_id" = {
              key = "machine_id";
              sopsFile = hostSopsFile;
            };
            "${hostName}/ssh/rsa" = {
              key = "ssh/rsa";
              sopsFile = hostSopsFile;
            };
            "${hostName}/ssh/ed25519" = {
              key = "ssh/ed25519";
              sopsFile = hostSopsFile;
            };
          };
        };

        services.openssh.generateHostKeys = lib.mkForce false;

        environment = {
          etc = {
            machine-id.source = config.sops.secrets."${hostName}/machine_id".path;
            "ssh/ssh_host_rsa_key".source = config.sops.secrets."${hostName}/ssh/rsa".path;
            "ssh/ssh_host_rsa_key.pub".source = boxen/${hostName}/ssh_host_rsa_key.pub;
            "ssh/ssh_host_ed25519_key".source = config.sops.secrets."${hostName}/ssh/ed25519".path;
            "ssh/ssh_host_ed25519_key.pub".source = boxen/${hostName}/ssh_host_ed25519_key.pub;
          };
        };
      };
  };
}
