{ pkgs
, ...
}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./ssh.nix
    ./impermanence.nix
    ./networkmanager.nix
  ];

  # Allow realtime priority to user processes
  security.rtkit.enable = true;

  # Desktop stuff
  programs.hyprland.enable = true;
  programs.zsh.enable = true;

  # Improved support for YubiKey
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Sound!
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Secrets!
  sops = {
    defaultSopsFile = ./secrets.yaml;
    # impermanence mounts aren't available when sops-nix starts
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    # Force host unlocking to *only* use age
    gnupg.sshKeyPaths = [ ];

    secrets = {
      passwd_tim.neededForUsers = true;
      # Secrets seem to need to be delcared before use, then filled in later when sops-nix runs
      networkmanager_env = { };
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" "DroidSansMono" "Hack" ]; })
    ];

    fontconfig.defaultFonts = {
      monospace = [ "CaskaydiaCove Nerd Font Mono" ];
    };
  };
}
