{
  inputs,
  ...
}:
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko/latest";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.disko = {
    imports = [
      inputs.disko.nixosModules.disko
    ];
  };

  flake.factory.diskoMainDevice =
    {
      config,
      mainDevice,
      swapSize ? "2G",
      encrypt ? false,
    }:
    let
      btrfsContent = {
        type = "btrfs";
        subvolumes = {
          root = {
            mountpoint = "/";
            mountOptions = [
              "compress=zstd"
              "noatime"
              "nodiratime"
            ];
          };
          nix = {
            mountpoint = "/nix";
            mountOptions = [
              "compress=zstd"
              "noatime"
              "nodiratime"
            ];
          };
          home = {
            mountpoint = "/home";
            mountOptions = [
              "compress=zstd"
              "noatime"
              "nodiratime"
            ];
          };
          persistence = inputs.self.lib.mkIfPersistence config {
            mountpoint = "/persist";
            mountOptions = [
              "compress=zstd"
              "noatime"
              "nodiratime"
            ];
          };
          swap = {
            mountpoint = "/swap";
            swap.swapfile.size = swapSize;
          };
        };
      };
      luksContent = {
        type = "luks";
        name = "crypted";
        settings.allowDiscards = true;
        content = btrfsContent;
      };
    in
    {
      disko.devices.disk.main = {
        type = "disk";
        device = mainDevice;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            OS = {
              size = "100%";
              content = if encrypt then luksContent else btrfsContent;
            };
          };
        };
      };
    };
}
