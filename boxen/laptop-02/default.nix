{
  imports = [
    ../common
    ./disko.nix
  ];

  networking.hostName = "laptop-02";
  nixpkgs.hostPlatform = "x86_64-linux"; 
  hardware.cpu.amd.updateMicrocode = true;
  time.timeZone = "Europe/Madrid"; 
  swapDevices = [ { device = "/swap/swapfile"; } ];
  
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
