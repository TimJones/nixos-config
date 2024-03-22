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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
    , nixos-generators
    , impermanence
    , sops-nix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.laptop-02 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          ./hardware
          ./configuration
        ];
      };

      packages.x86_64-linux.iso-laptop-02 = nixos-generators.nixosGenerate {
        format = "install-iso";
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          disko.nixosModules.disko
          ./hardware/disko.nix
          ({ config, pkgs, ... }:
            let
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
            in
            {
              # Don't generate the filesystem config since it's for the target rather than the installer ISO
              disko.enableConfig = false;
              environment.systemPackages = [
                diskoScript
                installScript
              ];
              # Use NetworkManager in place of wpa_supplicant
              networking = {
                wireless.enable = false;
                networkmanager.enable = true;
              };
              users.users.nixos.extraGroups = [ "networkmanager" ];
            })
        ];
      };
    };
}
