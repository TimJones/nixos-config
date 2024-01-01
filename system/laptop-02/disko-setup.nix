# Keep this file minimal as it is included in the installer ISO
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_4000GB_23270P802370";
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
          };
        };
        OS = {
          size = "100%";
          content = {
            type = "btrfs";
            postCreateHook = ''
              (
                btrfs_mnt=$(mktemp -d)
                mount /dev/disk/by-partlabel/disk-main-OS "$btrfs_mnt" -o subvol=/
                trap "umount $btrfs_mnt; rm -rf $btrfs_mnt" EXIT

                mkdir -p "$btrfs_mnt"/persistence/snapshots/{root,home} 
                btrfs subvolume snapshot -r "$btrfs_mnt/root" "$btrfs_mnt/persistence/snapshots/root/new"
                btrfs subvolume snapshot -r "$btrfs_mnt/home" "$btrfs_mnt/persistence/snapshots/home/new"
              )
            '';
            subvolumes = {
              "root" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
              };
              "nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
              };
              "swap" = {
                mountpoint = "/swap";
                swap = {
                  swapfile.size = "48G";
                };
              };
              "home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
              };
              "persistence" = {
                mountpoint = "/persist";
                mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
              };
            };
          };
        };
      };
    };
  };
}
