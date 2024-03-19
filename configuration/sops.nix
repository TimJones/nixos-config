{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    # impermanence mounts aren't available when sops-nix starts
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    # Force host unlocking to *only* use age
    gnupg.sshKeyPaths = [ ];
  };
}
