{ lib
, pkgs
, ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "terraform"
  ];

  home-manager.users.tim.home.packages = with pkgs; [
    awscli2
    azure-cli
    google-cloud-sdk
    terraform
  ];

  environment.persistence."/persist".users.tim.directories = [
    ".aws"
  ];
}
