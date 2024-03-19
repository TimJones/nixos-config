{ inputs
, outputs
, pkgs
, config
, ...
}: {
  # Use home-manager as a system module
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    # Set up home-manager for user
    users.tim = {
      home = {
        username = "tim";
        homeDirectory = "/home/tim";
        stateVersion = "23.11";
      };
      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
    };
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];

}
