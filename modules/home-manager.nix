{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.lib.mkHomeManager = system: stateVersion: name: {
    ${name} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        inputs.self.modules.homeManager.${name}
        {
          home.stateVersion = stateVersion;
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  };

  flake.modules.nixos.home-manager =
    { config, lib, ... }:{
      imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            verbose = true;
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            backupCommand = "rm";
            overwriteBackup = true;
            sharedModules = [
              {
                home.stateVersion = lib.mkDefault config.system.stateVersion;
              }
            ];
          };
        }
      ];
    };
}
