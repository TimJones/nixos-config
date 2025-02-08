{
  description = "NixOS config for Tim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , disko
    , home-manager
    , nixvim
    , impermanence
    , sops-nix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        laptop-02 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            mainDisk = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_4000GB_23270P802370";
            hostName = "laptop-02";
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            nixvim.nixosModules.nixvim
            ./hardware
            ./configuration
          ];
        };

        desktop-02 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            mainDisk = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_4000GB_23513M801557";
            hostName = "desktop-02";
          };
          modules = [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            nixvim.nixosModules.nixvim
            ./hardware
            ./configuration
          ];
        };
      };
    };
}
