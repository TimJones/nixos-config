{ config
, pkgs
, ...
}: {
  # Required for sops-managed password
  users.mutableUsers = false;
  sops.secrets."users/tim/passwd".neededForUsers = true;

  users.users.tim = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/tim/passwd".path;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpmeGNaB1+VCX2EsqI9eD5RvCdBqs34Xi8arCEsz4R8 tim@desktop-01"
    ];
  };

  # Impermanence directories for users
  environment.persistence."/persist".users.tim = {
    files = [
      ".ssh/id_ed25519"
      ".ssh/known_hosts"
    ];
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "projects"
    ];
  };
}
