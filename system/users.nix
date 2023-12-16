{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  # Use home-manager as a system module
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      tim = import ../home/tim;
    };
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];

  users.users = {
    tim = {
      isNormalUser = true;
      initialPassword = "bootstrap";
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };
}
