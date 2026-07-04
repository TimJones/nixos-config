# Bundles every host's system closure + disko script into the image so
# `disko-install` can partition and install a target with no network.
#
# Cribbed from https://github.com/nix-community/disko/blob/master/docs/disko-install.md
{ inputs, lib, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      (
        { pkgs, lib, ... }:
        let
          # Every nixosConfiguration except this one is an install target.
          boxenCfgs = removeAttrs inputs.self.nixosConfigurations [ "installer" ];
          boxen = builtins.attrNames boxenCfgs;

          # For every flake-input, collect its outPath to add to the store.
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

          # den resolves these at *evaluation* time reading the revs from its
          # own lock. They are neither binary-cache nor flake inputs, so nothing
          # else bundles them.
          fetchLocked =
            l:
            fetchTarball {
              url = "https://github.com/${l.owner}/${l.repo}/archive/${l.rev}.zip";
              sha256 = l.narHash;
            };
          denLock = builtins.fromJSON (builtins.readFile "${inputs.den}/templates/ci/flake.lock");

          genSchemaSrc = fetchLocked denLock.nodes.gen-schema.locked;
          nixEffectsSrc = fetchLocked denLock.nodes.nix-effects.locked;
          genSchemaLock = builtins.fromJSON (builtins.readFile "${genSchemaSrc}/ci/flake.lock");
          genAlgebraSrc = fetchLocked genSchemaLock.nodes.gen-algebra.locked;

          denEvalDeps = [
            genSchemaSrc
            nixEffectsSrc
            genAlgebraSrc
          ];

          # Everything needed to build a given target with no substituters.
          mkTargetDeps =
            name:
            let
              t = boxenCfgs.${name};
            in
            [
              t.config.system.build.toplevel
              t.config.system.build.diskoScript
              t.config.system.build.diskoScript.drvPath

              # Referenced by the activation script's perl deps.
              t.pkgs.perlPackages.ConfigIniFiles
              t.pkgs.perlPackages.FileSlurp

              (t.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
            ]
            ++ flakeOutPaths;

          closureInfo = pkgs.closureInfo {
            rootPaths = (lib.concatMap mkTargetDeps boxen) ++ denEvalDeps;
          };

          # `install-<host>` runs disko-install for that host, filling the
          # --disk flags from its own disko layout.
          # Add `--option substituters https://cache.nixos.org` to install with network access.
          mkInstallWrapper =
            name:
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

          # Disable substituters so a missing path fails loudly
          # instead of silently probing the cache.
          nix.settings = {
            substituters = lib.mkForce [ ];
            trusted-substituters = lib.mkForce [ ];
          };

          system.stateVersion = "26.05";
        }
      )
    ];
  };

  # Convenience package: `nix build .#installer-iso`
  perSystem = { system, ... }: {
    packages = lib.optionalAttrs (system == "x86_64-linux") {
      installer-iso = inputs.self.nixosConfigurations.installer.config.system.build.isoImage;
    };
  };
}
