{
  inputs,
  ...
}: {
  flake-file.inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  flake.modules.nixos."laptop-02" =
    { config, ... }:
    {
    imports = with inputs; [
      nixos-hardware.nixosModules.framework-13-7040-amd
      (self.factory.diskoMainDevice {
        inherit config;
        mainDevice = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4aaabae5";
        encrypt = true;
      })
    ];

    hardware = {
      cpu.amd.updateMicrocode = true;
      enableRedistributableFirmware = true;
    };
  };
}
