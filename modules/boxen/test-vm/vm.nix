{
  inputs,
  ...
}:
{
  flake.modules.nixos."test-vm" =
    { config, pkgs, ... }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
      ];

      environment.systemPackages = with pkgs; [
        swtpm
      ];

      virtualisation = {
        tpm.enable = true;
        vmVariantWithBootLoader.virtualisation = {
          memorySize = 4096;
          cores = 4;
        };

        vmVariantWithDisko = {
          virtualisation.fileSystems."/home".neededForBoot = true;
          virtualisation.fileSystems."/persist".neededForBoot = inputs.self.lib.mkIfPersistence config true;
        };

        forwardPorts = [
          {
            from = "host";
            host.port = 2222;
            guest.port = 22;
          }
        ];
      };
    };
}
