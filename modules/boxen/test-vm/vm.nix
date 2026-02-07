{
  flake.modules.nixos."test-vm" = {
    virtualisation.vmVariantWithBootLoader.virtualisation = {
      memorySize = 4096;
      cores = 4;
    };
  };
}
