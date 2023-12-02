{
  description = "NixOS config for Tim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    disko,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
     laptop-02 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
	  nixos-hardware.nixosModules.framework-13-7040-amd
	  disko.nixosModules.disko
          ./boxen/laptop-02
	  ./system/common
	  ./apps/common
        ];
      };
    };
  };
}
