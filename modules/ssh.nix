{
  den.aspects.ssh = {
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

    permHome = {
      # Needs to be a directory as known_hosts is updated via a temporary hardlink which fails across partitions.
      directories = [
        ".ssh"
      ];
    };
  };
}
