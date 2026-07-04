# Build & run a QEMU VM for *any* declared host:
#
#   nix run .#vm-<host>          # e.g. nix run .#vm-laptop-02
#   nix run .#vm <host>          # dispatcher; defaults to the sole host if only one
#   nix run .#vm-<host> -- ...   # extra args are forwarded to the run-*-vm script
#
# TPM is selected at *run time* via $VM_TPM (nothing is baked into the build, so
# the same VM image works for every mode):
#
#   VM_TPM=emulated  (default) start a fresh swtpm software TPM 2.0. Always works,
#                    but is a brand-new TPM: it cannot unseal secrets sealed to
#                    the real host TPM (the VM boots like the CI path, without
#                    host secrets).
#   VM_TPM=passthrough  hand the guest the host's TPM (VM_TPM_DEV, default
#                    /dev/tpm0). Mounts real hardware, but QEMU PCR values differ
#                    from a physical boot so host-sealed secrets still won't
#                    unseal, the host loses exclusive TPM access, and the build
#                    host must actually have a TPM.
#   VM_TPM=none      no TPM device.
{
  inputs,
  den,
  lib,
  ...
}:
let
  # Every declared host, flattened across systems (same enumeration den's own
  # nh lib uses in modules/nh.nix). Only NixOS hosts have `system.build.vm`.
  hosts = builtins.filter (h: h.class == "nixos") (
    lib.concatMap lib.attrValues (lib.attrValues den.hosts)
  );
in
{
  # VM-only tweaks for every host. `virtualisation.vmVariant` is merged into
  # `system.build.vm` ONLY, so none of this ever reaches a real hardware build.
  den.aspects.vm.nixos.virtualisation.vmVariant =
    { config, lib, ... }:
    {
      # Drop straight to a shell as the first normal user (falls back to root).
      services.getty.autologinUser = lib.mkDefault (
        let
          normalUsers = lib.attrNames (lib.filterAttrs (_: u: u.isNormalUser) config.users.users);
        in
        if normalUsers == [ ] then "root" else lib.head normalUsers
      );

      # Roomier than the 1-core / 1G nixos test-VM defaults.
      virtualisation = {
        cores = lib.mkDefault 4;
        memorySize = lib.mkDefault 4096;
        diskSize = lib.mkDefault 8192;
      };
    };

  den.default.includes = [ den.aspects.vm ];

  perSystem =
    { pkgs, system, ... }:
    let
      thisSystemHosts = builtins.filter (h: h.system == system) hosts;

      # Wrapper around a host's run-*-vm script that injects the chosen TPM
      # device via $QEMU_OPTS (see the file header for VM_TPM semantics).
      runner =
        host:
        let
          cfg = inputs.self.nixosConfigurations.${host.name}.config;
        in
        pkgs.writeShellApplication {
          name = "vm-${host.name}";
          runtimeInputs = [ pkgs.swtpm ];
          runtimeEnv = {
            RUN_VM = cfg.system.build.vm;
            VM_HOSTNAME = cfg.networking.hostName;
          };
          text = builtins.readFile ./tpm-qemu-wrapper.sh;
        };

      runners = map (h: {
        inherit h;
        drv = runner h;
      }) thisSystemHosts;

      perHost = lib.listToAttrs (
        map (r: {
          name = "vm-${r.h.name}";
          value = r.drv;
        }) runners
      );

      names = map (r: r.h.name) runners;
      # Default to the sole host when there is exactly one; else require an arg.
      defaultHost = if lib.length names == 1 then lib.head names else "";

      # `nix run .#vm [host] [-- qemu args...]` — dispatches to a per-host runner.
      # The runners are put on $PATH (as vm-<host>) and the host list / default
      # are passed as env vars, so dispatch.sh stays fully static.
      dispatcher = pkgs.writeShellApplication {
        name = "vm";
        runtimeInputs = map (r: r.drv) runners;
        runtimeEnv = {
          VM_HOSTS = lib.concatStringsSep " " names;
          VM_DEFAULT_HOST = defaultHost;
        };
        text = builtins.readFile ./dispatch.sh;
      };
    in
    {
      packages =
        perHost
        // lib.optionalAttrs (thisSystemHosts != [ ]) {
          vm = dispatcher;
        };
    };
}
