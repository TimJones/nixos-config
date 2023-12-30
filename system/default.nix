{
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./ssh.nix
    ./impermanence.nix
  ];

  # Allow realtime priority to user processes
  security.rtkit.enable = true;

  # Use NetworkManager
  networking.networkmanager.enable = true;
  users.users.tim.extraGroups = [ "networkmanager" ];

  # Desktop stuff
  programs.hyprland.enable = true;
  programs.zsh.enable = true;

  # Improved support for YubiKey
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Secrets!
  sops = {
    defaultSopsFile = ./secrets.yaml;
    # impermanence mounts aren't available when sops-nix starts
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    # Force host unlocking to *only* use age
    gnupg.sshKeyPaths = [];
  };
}
