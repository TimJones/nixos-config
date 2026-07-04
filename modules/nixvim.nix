{ inputs, ... }:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.flake-parts.follows = "flake-parts";
  };

  den.aspects.nixvim = {
    homeManager = {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim.enable = true;
    };
  };
}
