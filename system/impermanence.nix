{
  lib,
  ...
}: {
  fileSystems."/persist".neededForBoot = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir -p /mnt/disk-main-OS
    mount /dev/disk/by-partlabel/disk-main-OS /mnt/disk-main-OS -o subvol=/
    btrfs subvolume delete /mnt/disk-main-OS/rootfs/*
    btrfs subvolume snapshot /mnt/disk-main-OS/rootfs-clean /mnt/disk-main-OS/rootfs
    umount /dev/disk-main-OS
    rm -rf /mnt/disk-main-OS
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
