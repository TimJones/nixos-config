{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    impermanence.url = "github:nix-community/impermanence";
  };

  # convenience function to set persistence settings only,
  # if impermanence module was imported
  # See https://github.com/Doc-Steve/dendritic-design-with-flake-parts/blob/main/modules/nix/tools/impermanence%20%5BN%5D/impermanence.nix
  flake.lib = {
    mkIfPersistence =
      config: settings:
      if config ? home then
        (if config.home ? persistence then settings else { })
      else
        (if config.environment ? persistence then settings else { });
  };

  flake.modules.nixos.impermanence = {
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    environment.persistence."/persist" = {
      directories = [
        "/var/lib/nixos"
      ];
    };
  };
}
