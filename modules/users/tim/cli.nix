{ den, ... }:
{
  den.aspects.tim.provides.cli = {
    includes = [
      (den.batteries.unfree [
        "terraform"
        "vault"
        "omnictl"
      ])
      den.aspects.tim.ssh
      den.aspects.tim.git
      den.aspects.tim.direnv
      den.aspects.tim.nixvim
      den.aspects.tim.gpg
      den.aspects.tim.password-store
      den.aspects.tim.docker
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # Dev tools
          gnumake
          go
          gotools
          kubebuilder

          # Ops tools
          jq
          yq-go
          ldns
          rclone
          vendir
          vault

          # Cloud tools
          talosctl
          omnictl
          kubectl
          kustomize
          kubernetes-helm
          terraform
        ];
      };
  };
}
