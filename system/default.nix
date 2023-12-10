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
}
