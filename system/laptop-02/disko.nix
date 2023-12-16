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
	      "DATA/logs" = {
	        mountpoint = "/var/logs";
	        mountOptions = [ "compress=zstd" "noatime" "nodiratime" ];
	      };
	    };
	  };
	};
      };
    };
  };
}
