{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.sops-nix = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];

        config = {
          environment.systemPackages = with pkgs; [
            sops
            ssh-to-age
            age
          ];
        };
      };

    homeManager = {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
    };
  };
}
