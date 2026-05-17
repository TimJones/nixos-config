{
  flake.modules.home-manager.dev-tools = { pkgs,  ... }: {
    home.packages = with pkgs; [
      git
      gnumake
      golang
      gotools
    ];
  };
}
