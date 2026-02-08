{
  inputs,
  ...
}:
{
  flake.modules.nixos."test-vm" = {
    imports = [
      "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    ];

    virtualisation = {
      vmVariantWithBootLoader.virtualisation = {
        memorySize = 4096;
        cores = 4;
      };
      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
      ];
    };
  };
}
