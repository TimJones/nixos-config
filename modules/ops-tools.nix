{
  flake.modules.home-manager.ops-tools = { pkgs,  ... }: {
    home.packages = with pkgs; [
      kustomize
      kubernetes-helm
      kubectl
      crane
      go-yq
      jq
      ldns
      direnv
      minicom
      ipmitool
    ];
  };
}
