{
  den,
  lib,
  inputs,
  ...
}:
{
  flake-file.inputs = {
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.batteries = {
    # Cribbed from https://den.denful.dev/guides/custom-classes/#example-an-impermanence-class
    permSys =
      { class, aspect-chain }:
      den.batteries.forward {
        each = lib.singleton true;
        fromClass = _item: "permSys";
        intoClass = _item: class;
        intoPath =
          _item:
          { config, ... }:
          [
            "environment"
            "persistence"
            config.impermanence.persistence-dir
          ];
        fromAspect = _item: lib.head aspect-chain;
        guard = { options, ... }: options ? environment.persistence;
      };

    permHome =
      { aspect-chain }:
      den.batteries.forward {
        each = lib.singleton true;
        fromClass = _item: "permHome";
        intoClass = _item: "homeManager";
        intoPath =
          _item:
          { osConfig, ... }:
          [
            "home"
            "persistence"
            osConfig.impermanence.persistence-dir
          ];
        fromAspect = _item: lib.head aspect-chain;
        guard = { options, ... }: options ? home.persistence;
      };
  };

  den.schema = {
    host.includes = [ den.batteries.permSys ];
    user.includes = [ den.batteries.permHome ];
  };

  den.aspects.impermanence = {
    nixos =
      { config, lib, ... }:
      let
        persistenceDir = config.impermanence.persistence-dir;
      in
      {
        imports = [ inputs.impermanence.nixosModules.impermanence ];

        options.impermanence.persistence-dir = lib.mkOption {
          description = "Root directory where persisted state is stored.";
          type = lib.types.str;
          default = "/nix/persist";
          example = "/persist";
        };

        config = {
          programs.fuse.userAllowOther = lib.mkForce true;

          fileSystems = {
            "/home".neededForBoot = true;
            "${persistenceDir}".neededForBoot = true;
          };

          environment.persistence."${persistenceDir}".directories = [
            "/var/lib/nixos" # For uid/gids not to be regenerated on every boot
            "/var/lib/sudo/lectured" # sudo nag screen
            "/var/lib/systemd/timers" # Timestampes for systemd tasks
          ];

          boot.initrd.systemd.services.impermanence = {
            description = "Restore the clean snapshots and keep old snapshots available for 30 days";
            wantedBy = [ "initrd.target" ];
            before = [ "sysroot.mount" ];
            serviceConfig.Type = "oneshot";
            script = builtins.replaceStrings [ "@persistenceDir@" ] [ config.impermanence.persistence-dir ] (
              builtins.readFile ./clean-disk.sh
            );
          };
        };
      };

    homeManager = {
      imports = [ inputs.impermanence.homeManagerModules.impermanence ];
    };
  };
}
