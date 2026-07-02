{ den, ... }:
{
  den.aspects.ssh = {
    includes = [ den.aspects.host-secrets ];

    nixos =
      { config, lib, ... }:
      let
        hostName = config.networking.hostName;
        hostSopsFile = boxen/${hostName}/secrets.yaml;
      in
      {
        sops.secrets = {
          "${hostName}/ssh/rsa" = {
            key = "ssh/rsa";
            sopsFile = hostSopsFile;
          };
          "${hostName}/ssh/ed25519" = {
            key = "ssh/ed25519";
            sopsFile = hostSopsFile;
          };
        };

        services.openssh = {
          enable = true;
          openFirewall = true;
          generateHostKeys = lib.mkForce false;
          settings = {
            UseDns = true;
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };

        environment = {
          etc = {
            "ssh/ssh_host_rsa_key".source = config.sops.secrets."${hostName}/ssh/rsa".path;
            "ssh/ssh_host_rsa_key.pub".source = boxen/${hostName}/ssh_rsa.pub;
            "ssh/ssh_host_ed25519_key".source = config.sops.secrets."${hostName}/ssh/ed25519".path;
            "ssh/ssh_host_ed25519_key.pub".source = boxen/${hostName}/ssh_ed25519.pub;
          };
        };
      };

    permHome = {
      # Needs to be a directory as known_hosts is updated via a temporary hardlink which fails across partitions.
      directories = [
        ".ssh"
      ];
    };
  };
}
