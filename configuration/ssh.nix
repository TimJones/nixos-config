{ config
, ...
}: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      UseDns = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  sops.secrets = {
    "boxen/laptop-02/ssh/rsa" = { };
    "boxen/laptop-02/ssh/ed25519" = { };
  };

  environment.etc = {
    "ssh/ssh_host_rsa_key" = {
      source = config.sops.secrets."boxen/laptop-02/ssh/rsa".path;
      mode = "0400";
    };
    "ssh/ssh_host_ed25519_key" = {
      source = config.sops.secrets."boxen/laptop-02/ssh/ed25519".path;
      mode = "0400";
    };
  };
}
