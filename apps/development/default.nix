{
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.tig
    pkgs.gnumake
  ];
}
