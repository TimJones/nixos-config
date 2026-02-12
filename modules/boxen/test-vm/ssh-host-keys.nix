{
  flake.modules.nixos."test-vm" =
    { config, ... }:
    {
      sops.secrets = {
        "test-vm/ssh/rsa" = {
          sopsFile = ./secrets.yaml;
          key = "ssh/rsa";
        };
        "test-vm/ssh/ed25519" = {
          sopsFile = ./secrets.yaml;
          key = "ssh/ed25519";
        };
      };

      services.openssh.generateHostKeys = false;
      environment.etc = {
        "ssh/ssh_host_rsa_key".source = config.sops.secrets."test-vm/ssh/rsa".path;
        "ssh/ssh_host_ed25519_key".source = config.sops.secrets."test-vm/ssh/ed25519".path;
      };
    };
}
