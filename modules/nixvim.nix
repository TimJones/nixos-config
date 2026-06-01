{
  inputs,
  ...
}:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
  };

  flake.modules.homeManager.nixvim = {
    imports = [
      inputs.nixvim.homeModules.nixvim
    ];

    programs.nixvim.enable = true;
  };
}
