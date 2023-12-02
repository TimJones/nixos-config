{
  pkgs,
  ...
}: {
  programs.git.enable = true;

  environment.systemPackages = [
    pkgs.tig
    pkgs.gnumake
  ];
}
