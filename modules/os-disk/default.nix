{ inputs, ... }:
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.os-disk.nixos =
    {
      config,
      options,
      lib,
      ...
    }:
    let
      cfg = config.os-disk;

      withImperm = options ? environment.persistence;

      btrfsContent = {
        type = "btrfs";
        extraArgs = [
          "-L"
          "os-root"
          "-f"
        ];
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
          swap = {
            mountpoint = "/swap";
            swap.swapfile.size = cfg.swap.size;
          };
        }
        // lib.optionalAttrs withImperm {
          persist = {
            mountpoint = config.impermanence.persistence-dir;
            mountOptions = [
              "compress=zstd"
              "noatime"
              "nodiratime"
            ];
          };
        };
        postCreateHook = lib.mkIf withImperm (builtins.readFile ./create-clean-snapshots.sh);
      };

      luksContent = {
        type = "luks";
        name = "crypted";
        settings = {
          allowDiscards = true;
          crypttabExtraOpts = [ "tpm2-device=auto" ];
        };
        content = btrfsContent;
      };

      rootContent = if cfg.encryption.enable then luksContent else btrfsContent;
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      options.os-disk = {
        rootDevice = lib.mkOption {
          description = "Device to use for the system disk";
          type = lib.types.str;
          example = "/dev/disk/by-id/nvme-eui.0000xyz...";
        };

        swap.size = lib.mkOption {
          description = "Size of the swap file";
          type = lib.types.strMatching "^([0-9]+[KMGTP])?$";
          default = "8G";
          example = "16G";
        };

        encryption.enable = lib.mkEnableOption "LUKS encryption of the root partition";
      };

      config = {
        disko.devices.disk.main = {
          type = "disk";
          device = cfg.rootDevice;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = rootContent;
              };
            };
          };
        };
      };
    };
}
