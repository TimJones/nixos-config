# NixOS Config

This is the NixOS configuration for my general purpose machines.  
I give no warranty, accept zero liability; use at your own risk, here be
dragons, yadda yadda yadda.

## Tooling/Dependencies

* [Denful Framework](https://den.denful.dev/) to configure and maintain
various NixOS boxen.
* [disko](https://github.com/nix-community/disko) for system partition
& filesystem management.

## Use

* `nix run .#write-flake` (re)generate flake.nix (when changing flake inputs).
* `nix flake lock` (re)generate flake.lock.
* `nix flake update` update all flakes in flake.lock.
* `nix flake check` check flake parses correctly.
* `nix run .#<name>` build the `<name>` configuration.
* `nix run .#<name> -- switch` switch to configuration for `<name>`.

## Layout

### `modules/boxen/<name>`

Each box is defined here, loosely following standard NixOS conventions.

* `default.nix`: Denful host declaration.
* `configuration.nix`: Software configuration, including system-wide aspects.
* `hardware.nix`: Hardware definitions, including system-wide aspects.

### `modules/users/<name>`

User definitions.  
Mostly using homeManager and independent aspects, but more complex setup can
separate into a system aspect and per-user configuration aspects if needed.

### `modules`

General use aspects.  
Aspects should generally be kept to a single file, named `<aspect-name>.nix`.  
Aspects that need to include larger scripts or additional definitions get
sub-directories, named `<aspect-name>/default.nix`.
