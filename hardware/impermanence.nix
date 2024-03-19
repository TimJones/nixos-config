{ lib
, ...
}: {
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    (
      btrfs_mnt=$(mktemp -d)
      mount /dev/disk/by-partlabel/disk-main-OS "$btrfs_mnt" -o subvol=/
      trap "umount $btrfs_mnt; rm -rf $btrfs_mnt" EXIT

      delete_subvolume_recursively() {
        IFS=$'\n'
        for vol in $(btrfs subvolume list -o "$1" | cut -d ' ' -f 9-); do
          delete_subvolume_recursively "$btrfs_mnt/$vol"
        done
        btrfs subvolume delete "$1"
      }

      for vol in root home; do
        if [[ -e "$btrfs_mnt/$vol" ]] && [[ -e "$btrfs_mnt/persistence/snapshots/$vol/new" ]]; then
            timestamp=$(date --date="@$(stat -c %Y $btrfs_mnt/$vol)" "+%Y-%m-%-d_%H:%M:%S")
            mv "$btrfs_mnt/$vol" "$btrfs_mnt/persistence/snapshots/$vol/$timestamp"
        fi

        btrfs subvolume snapshot "$btrfs_mnt/persistence/snapshots/$vol/new" "$btrfs_mnt/$vol"

        for snap in $(find "$btrfs_mnt/persistence/snapshots/$vol/" -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$snap"
        done
      done
    )
  '';

  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
    ];
    directories = [
      "/var/log"
    ];
  };
}
