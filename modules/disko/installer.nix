{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "installer";

  flake.modules.nixos.installer =
    { pkgs, lib, ... }:
    let
      # Enumerate installation targets by pulling all nixosConfigurations (except this one)
      boxenCfgs = builtins.removeAttrs inputs.self.nixosConfigurations [ "installer" ];
      boxen = builtins.attrNames boxenCfgs;

      # Cribbed from https://github.com/nix-community/disko/blob/master/docs/disko-install.md#example-for-a-nixos-installer
      flakeOutPaths =
        let
          collector =
            parent:
            map (
              child:
              [ child.outPath ] ++ (if child ? inputs && child.inputs != { } then (collector child) else [ ])
            ) (lib.attrValues parent.inputs);
        in
        lib.unique (lib.flatten (collector inputs.self));

      # Adapted to allow mapping boxen dependencies
      mkTargetDeps = name:
        let t = boxenCfgs.${name}; in [
          t.config.system.build.toplevel
          t.config.system.build.diskoScript
          t.config.system.build.diskoScript.drvPath

          # https://github.com/NixOS/nixpkgs/blob/f2fd33a198a58c4f3d53213f01432e4d88474956/nixos/modules/system/activation/top-level.nix#L342
          t.pkgs.perlPackages.ConfigIniFiles
          t.pkgs.perlPackages.FileSlurp

          (t.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
        ] ++ flakeOutPaths;

      closureInfo = pkgs.closureInfo { rootPaths = lib.concatMap mkTargetDeps boxen; };

      mkInstallWrapper = name:
        let
          disks = boxenCfgs.${name}.config.disko.devices.disk;
          diskFlags = lib.concatStringsSep " " (
            lib.mapAttrsToList (diskName: cfg: "--disk ${diskName} ${cfg.device}") disks
          );
        in
        pkgs.writeShellApplication {
          name = "install-${name}";
          runtimeInputs = [ pkgs.disko ];
          text = ''
            exec disko-install \
              --flake ${inputs.self}#${name} \
              ${diskFlags} \
              "$@"
          '';
        };
    in
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ];

      environment = {
        etc."install-closure".source = "${closureInfo}/store-paths";
        systemPackages = map mkInstallWrapper boxen;
      };

      networking.hostName = lib.mkForce "nixos-installer";
      image.baseName = lib.mkForce "nixos-offline-installer";

      # The whole point of this ISO is offline install. Disable substituters
      # so a missing dependency aborts with a clear "path is not valid" error
      # instead of silently chewing through cache.nixos.org probes that time
      # out. To install with network access, override at runtime by passing
      # `--option substituters https://cache.nixos.org` through the wrapper.
      nix.settings = {
        substituters = lib.mkForce [ ];
        trusted-substituters = lib.mkForce [ ];
      };
    };
}
