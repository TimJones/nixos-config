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
		btrfs subvolume snapshot -r "$MNTPOINT"/SYSTEM/rootfs "$MNTPOINT"/SYSTEM/rootfs-clean
	      )
	      (
	        MNTPOINT=$(mktemp -d)
		mount /dev/disk/by-partlabel/disk-main-OS "$MNTPOINT" -o subvol=/
		trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
		btrfs subvolume snapshot -r "$MNTPOINT"/DATA/home "$MNTPOINT"/DATA/home-clean
	      )
	    '';
	    subvolumes = {
	      "SYSTEM" = {};
	      "SYSTEM/rootfs" = {
	        mountpoint = "/";
	        mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
	      };
	      "SYSTEM/nix" = {
	        mountpoint = "/nix";
	        mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
	      };
	      "SYSTEM/swap" = {
	        mountpoint = "/swap";
		swap = {
		  swapfile.size = "48G";
		};
  	      };
	      "DATA" = {};
	      "DATA/home" = {
	        mountpoint = "/home";
	        mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
	      };
	      "DATA/persistence" = {
	        mountpoint = "/persist";
	        mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
	      };
	      "DATA/snapshots" = {
	        mountpoint = "/snapshots";
	        mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
	      };
	    };
	  };
	};
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
