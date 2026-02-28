{
  inputs,
  ...
}:
{
  flake.modules.nixos.tpmHostSecrets =
    { config, pkgs, ... }:
    let
      hostName = config.networking.hostName;
    in
    {
      imports = with inputs.self.modules.nixos; [
        sops-nix
        tpm
      ];

      # Must ensure the TPM key file is available before system activation
      boot.initrd.postDeviceCommands = ''
        cp -r ${./boxen/${hostName}/tpm.age} /run/tpm.age
        chmod -R 700 /run/tpm.age
      '';

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
            sopsFile = ./boxen/${hostName}/secrets.yaml;
            key = "machine_id";
          };
          "${hostName}/ssh/rsa" = {
            sopsFile = ./boxen/${hostName}/secrets.yaml;
            key = "ssh/rsa";
          };
          "${hostName}/ssh/ed25519" = {
            sopsFile = ./boxen/${hostName}/secrets.yaml;
            key = "ssh/rsa";
          };
        };
      };

      services.openssh.generateHostKeys = false;

      environment = {
        etc = {
          machine-id.source = config.sops.secrets."${hostName}/machine_id".path;
          "ssh/ssh_host_rsa_key".source = config.sops.secrets."${hostName}/ssh/rsa".path;
          "ssh/ssh_host_rsa_key.pub".source = ./boxen/${hostName}/ssh_host_rsa_key.pub;
          "ssh/ssh_host_ed25519_key".source = config.sops.secrets."${hostName}/ssh/ed25519".path;
          "ssh/ssh_host_ed25519_key.pub".source = ./boxen/${hostName}/ssh_host_ed25519_key.pub;
        };

        systemPackages = with pkgs; [
          age-plugin-tpm
        ];
      };
    };
}
