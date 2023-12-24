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
	        MNTPOINT=$(mktemp -d)
		mount /dev/disk/by-partlabel/disk-main-OS "$MNTPOINT" -o subvol=/
		trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
		mkdir -p "$MNTPOINT"/persistence/snapshots
		btrfs subvolume snapshot -r "$MNTPOINT"/rootfs "$MNTPOINT"/persistence/snapshots/clean-rootfs
		btrfs subvolume snapshot -r "$MNTPOINT"/home "$MNTPOINT"/persistence/snapshots/clean-home
	      )
	    '';
	    subvolumes = {
	      "rootfs" = {
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
