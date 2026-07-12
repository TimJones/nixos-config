{ inputs, ... }:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
  };

  den.aspects.tim.provides.stylix = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.homeModules.stylix ];

        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

          fonts.monospace = {
            package = pkgs.nerd-fonts.hack;
            name = "Hack Nerd Font Mono";
          };
        };
      };
  };
}
