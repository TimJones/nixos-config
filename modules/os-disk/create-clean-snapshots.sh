(
  btrfs_mnt=$(mktemp -d)
  mount -L os-root "${btrfs_mnt}" -o subvol=/
  trap "umount ${btrfs_mnt}; rm -rf ${btrfs_mnt}" EXIT

  # Store the clean "new" snapshots inside the persist subvolume, which is never
  # rolled back and is mounted at the persistence dir at runtime. They live under
  # a dedicated persist/snapshots/ tree so they never sit alongside persisted
  # state (e.g. persist/home/<user>).
  for vol in root home; do
    mkdir -p "${btrfs_mnt}/persist/snapshots/${vol}"
    btrfs subvolume snapshot -r "${btrfs_mnt}/${vol}" "${btrfs_mnt}/persist/snapshots/${vol}/new"
  done
)
