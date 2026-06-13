{
  inputs,
  ...
}:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
  };

  flake.modules.homeManager.stylix = {
    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix.enable = true;
  };
}
