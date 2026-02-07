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
}
