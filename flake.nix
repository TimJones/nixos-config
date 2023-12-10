{
  description = "NixOS config for Tim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    disko,
    home-manager,
    nixvim,
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
	  ./system
	  ./system/hde
        ];
      };
    };

    homeConfigurations = {
      "tim@laptop-02" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
	   nixvim.homeManagerModules.nixvim
	  ./home/tim
	];
      };
    };
  };
}
