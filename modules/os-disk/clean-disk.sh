(
  btrfs_mnt=$(mktemp -d)
  mount -L os-root "${btrfs_mnt}" -o subvol=/
  trap "umount ${btrfs_mnt}; rm -rf ${btrfs_mnt}" EXIT

  delete_subvolume_recursively() {
    local sub IFS=$'\n'
    for sub in $(btrfs subvolume list -o "${1}" | cut -d ' ' -f 9-); do
      delete_subvolume_recursively "${btrfs_mnt}/${sub}"
    done
    btrfs subvolume delete "${1}"
  }

  for vol in root home; do
    snap_dir="${btrfs_mnt}/persist/snapshots/${vol}"

    if [[ -e "${btrfs_mnt}/${vol}" ]] && [[ -e "${snap_dir}/new" ]]; then
        timestamp=$(date --date="@$(stat -c %Y ${btrfs_mnt}/${vol})" "+%Y-%m-%-d_%H:%M:%S")
        btrfs subvolume snapshot -r "${btrfs_mnt}/${vol}" "${snap_dir}/${timestamp}"
        delete_subvolume_recursively "${btrfs_mnt}/${vol}"
    fi

    btrfs subvolume snapshot "${snap_dir}/new" "${btrfs_mnt}/${vol}"

    for snap in $(find "${snap_dir}/" -mindepth 1 -maxdepth 1 -mtime +30 -not -name new); do
      btrfs property set "${snap}" ro false
      delete_subvolume_recursively "${snap}"
    done
  done
)
