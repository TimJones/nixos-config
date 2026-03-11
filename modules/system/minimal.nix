{
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  flake.modules.nixos.system-minimal = {
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
        directory = "/home/${config.home.username}";
        stateVersion = "25.11";
      };
    };
}
