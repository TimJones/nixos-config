{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-terminal = {
    imports = with inputs.self.modules.nixos; [
      system-minimal
      ssh
      sops-nix
      disko
      impermanence
      home-manager
    ];
  };

  flake.modules.homeManager.system-terminal = {
    imports = with inputs.self.modules.homeManager; [
      system-minimal
      sops-nix
    ];
  };
}
