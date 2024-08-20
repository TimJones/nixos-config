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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeARwxKKnkeyeGJIbmt5wXPj6nKbEmmw0mI87Lbwvvj tim@nixos"
    ];
  };

  sops.secrets."users/tim/ssh/ed25519" = {
    mode = "0400";
    owner = config.users.users.tim.name;
    group = config.users.users.tim.group;
    path = "${config.users.users.tim.home}/.ssh/id_ed25519";
  };

  environment.persistence."/persist".users.tim = {
    files = [
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
