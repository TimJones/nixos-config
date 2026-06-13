{
  inputs,
  ...
}:
{
  flake.modules.homeManager.tim =
  { pkgs, ... }:
  {
    imports = with inputs.self.modules.homeManager; [
      stylix
    ];
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
}
