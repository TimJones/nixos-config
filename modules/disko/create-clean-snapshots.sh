(
  btrfs_mnt=$(mktemp -d)
  mount -L os-root "${btrfs_mnt}" -o subvol=/
  trap "umount ${btrfs_mnt}; rm -rf ${btrfs_mnt}" EXIT

  for vol in root home; do
    mkdir -p "${btrfs_mnt}/persist/snapshots/${vol}"
    btrfs subvolume snapshot -r "${btrfs_mnt}/${vol}" "${btrfs_mnt}/persist/snapshots/${vol}/new"
  done
)
