{
  imports = [
    ./nix.nix
    ./users.nix
    ./ssh.nix
  ];

  # Allow realtime priority to user processes
  security.rtkit.enable = true;

  # Use NetworkManager
  networking.networkmanager.enable = true;
  users.users.tim.extraGroups = [ "networkmanager" ];

  # Desktop stuff
  programs.hyprland.enable = true;
  programs.zsh.enable = true;

  # Impermanence
  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    directories = [
      "/var/log"
    ];
  };
}
