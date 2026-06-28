{ den, inputs, ... }:
{
  flake-file.inputs = {
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.laptop-02 = {
    includes = [ den.aspects.os-disk ];

    nixos = {
      imports = [
        (inputs.nixos-hardware.nixosModules.framework-13-7040-amd or { })
      ];

      hardware = {
        cpu.amd.updateMicrocode = true;
        enableRedistributableFirmware = true;
      };

      os-disk = {
        rootDevice = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4aaabae5";
        encryption.enable = true;
      };
    };
  };
}
