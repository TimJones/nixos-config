{
  inputs,
  ...
}:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix?rev=525965744b770af79c985ae5c43c65e441dc8b29";
  };

  flake.modules.homeManager.stylix = {
    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix.enable = true;
    stylix.autoEnable = false;
  };
}
