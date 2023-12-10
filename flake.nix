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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
    nixos-generators,
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

    packages.x86_64-linux = {
      iso-laptop-02 = nixos-generators.nixosGenerate {
        format = "install-iso";
	system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
	modules = [
	  disko.nixosModules.disko
	  ./boxen/laptop-02/disko.nix
	  ({ config, pkgs, ...}: let
	    systemDev = self.nixosConfigurations."laptop-02".config.system.build.toplevel;
	    diskoScript = pkgs.writeShellScriptBin "disko" "${config.system.build.diskoScript}";
	    installScript = pkgs.writeShellScriptBin "install-system" ''
	      set -euo pipefail

	      echo "Setting up disks..."
	      . ${diskoScript}/bin/disko

	      echo "Installing system..."
	      nixos-install --no-root-passwd --system ${systemDev}

	      echo "Done!"
	    '';
	  in {
	    # Don't generate the filesystem config since it's for the target rather than the installer ISO
            disko.enableConfig = false;
	    environment.systemPackages = [
	      diskoScript
	      installScript
            ];
	  })
        ];
      };
    };
  };
}
