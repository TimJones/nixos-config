{
  lib,
  ...
}: {
  fileSystems."/persist".neededForBoot = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    MNTPOINT=$(mktemp -d)
    mount /dev/disk/by-partlabel/disk-main-OS "$MNTPOINT" -o subvol=/
    
    if [[ -e "$MNTPOINT/rootfs" ]]; then
        mkdir -p "$MNTPOINT/old_roots"
        timestamp=$(date --date="@$(stat -c %Y $MNTPOINT/rootfs)" "+%Y-%m-%-d_%H:%M:%S")
        mv "$MNTPOINT/rootfs" "$MNTPOINT/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "$MNTPOINT/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find $MNTPOINT/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create $MNTPOINT/rootfs

    umount "$MNTPOINT"
    rm -rf "$MNTPOINT"
  '';

  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    directories = [
      "/var/log"
    ];
  };
}
