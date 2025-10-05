{
	inputs,
	pkgs,
	...
}: {
	imports = [
		inputs.nixos-hardware.nixosModules.common-cpu-amd
		inputs.nixos-hardware.nixosModules.common-gpu-amd
		inputs.nixos-hardware.nixosModules.common-pc-ssd
	];

	config = {
		networking.hostName = "desktop-02";
		system.stateVersion = "23.11";
		nixpkgs.hostPlatform = "x86_64-linux";

		hardware = {
			bluetooth.enable = true;
			enableRedistributableFirmware = true;
			keyboard.zsa.enable = true;
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
					"usb_storage"
					"sd_mod"
				];
			};
		};

		systemd.network = {
			enable = true;

			networks."home" = {
				matchConfig.Name = "eno1";
				networkConfig.DHCP = "ipv4";
				linkConfig.RequiredForOnline = "routable";
			};
		};

		time.timeZone = "Europe/Madrid";
	};
}
