{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./sops.nix
    ./network.nix
    ./ssh.nix
    ./home-manager.nix
    ./users.nix
    ./fonts.nix
    ./shell.nix
    ./git.nix
    ./neovim
    ./gpg.nix
    ./password-store.nix
    ./regreet
    ./hyprland
    ./firefox.nix
    ./gaming.nix
    ./fingerprint.nix
    ./bluetooth.nix
    ./slack.nix
    ./wayland.nix
    ./k8s.nix
  ];

  # General system config
  networking.hostName = "laptop-02";
  time.timeZone = "Europe/Madrid";

  # Nix-specific settings
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  };

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  # Sound!
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Allow realtime priority to user processes
  security.rtkit.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
