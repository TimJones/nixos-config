{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    kubectl
    talosctl
    omnictl
    krew
    kubelogin-oidc
    kustomize
    helm
  ];

  environment.persistence."/persist".users.tim.directories = [
    ".kube"
    ".talos"
    ".config/omni"
    ".local/share/omni"
  ];
}
