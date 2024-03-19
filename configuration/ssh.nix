{
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  environment.persistence."/persist" = {
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
