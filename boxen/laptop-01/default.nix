{
	inputs,
	pkgs,
	...
}: {
	imports = [
		inputs.nixos-hardware.nixosModules.framework-13-7040-amd
	];

	config = {
		networking.hostName = "laptop-02";
		system.stateVersion = "25.05";
		nixpkgs.hostPlatform = "x86_64-linux";

		hardware = {
			bluetooth.enable = true;
			enableRedistributableFirmware = true;
		};

		boot = {
			kernelPackages = pkgs.linuxPackages_latest;
			kernelModules = [
				"kvm-amd"
			];
			loader = {
				systemd-boot.enable = true;
				efi.canTouchEfiVariables = true;
			};
			initrd = {
				availableKernelModules = [
					"nvme"
					"xhci_pci"
					"thunderbolt"
					"usb_storage"
					"sd_mod"
				];
			};
		};

		services = {
			fwupd.enable = true;
			hardware.bolt.enable = true;
			automatic-timezoned.enable = true;
			geoclue2 = {
				submissionUrl = "https://api.beacondb.net/v2/geosubmit";
				geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
			};
		};
	};
}
