{
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.git
    pkgs.tig
    pkgs.gnumake
  ];
}
