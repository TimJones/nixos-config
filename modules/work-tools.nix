
{
  flake.modules.home-manager.work-tools = { pkgs,  ... }: {
    home.packages = with pkgs; [
      talosctl
      omnictl
      _1password
    ];
  };
}
