{
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  flake.modules.nixos.system-minimal = {
    boot = {
      initrd.systemd.enable = true;
      loader.systemd-boot.enable = true;
    };

    nixpkgs.config.allowUnfree = true;

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';
    };
  };

  flake.modules.homeManager.system-minimal =
    {
      config,
      ...
    }:
    {
      home = {
        homeDirectory = "/home/${config.home.username}";
      };
    };
}
