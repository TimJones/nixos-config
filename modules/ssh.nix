{
  inputs,
  ...
}:
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        UseDns = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  flake.modules.homeManager.ssh =
    { config, ... }:
    {
      home.persistence."/persist" = inputs.self.lib.mkIfPersistence config {
        # Needs to be a directory as known_hosts is updated via a temporary hardlink which fails across partitions.
        directories = [
          ".ssh"
        ];
      };
    };
}
