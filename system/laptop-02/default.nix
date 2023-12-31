{
  imports = [
    ./disko-setup.nix
  ];

  networking.hostName = "laptop-02";
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Europe/Madrid";

  hardware = {
    bluetooth.enable = true;
    sensor.iio.enable = true;
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
