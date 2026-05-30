{
  inputs,
  lib,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  options.flake.factory = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config = {
    # Helper functions for creating system
    # See https://github.com/Doc-Steve/dendritic-design-with-flake-parts/blob/main/modules/nix/flake-parts%20%5B%5D/lib.nix
    flake.lib.mkNixos = system: stateVersion: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          {
            networking.hostName = lib.mkDefault name;
            nixpkgs.hostPlatform = lib.mkDefault system;
            system.stateVersion = lib.mkDefault stateVersion;
          }
        ];
      };
    };
    perSystem =
      { pkgs, ... }:
      {
        formatter = pkgs.nixfmt;
      };
  };
}
