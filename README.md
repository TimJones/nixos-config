# NixOS Config

This is the NixOS configuration for my general purpose machines.  
I give no warranty, accept zero liability; use at your own risk, here be
dragons, yadda yadda yadda.

## Tooling/Dependencies

* [Denful Framework](https://den.denful.dev/) to configure and maintain
various NixOS boxen.
* [disko](https://github.com/nix-community/disko) for system partition
& filesystem management.
* [impermanence](https://github.com/nix-community/impermanence) for permanent
system state.
* [sops-nix](https://github.com/mic92/sops-nix) for secrets management.
* [Hyprland](https://wiki.hypr.land/) Wayland compositor with
[dms](https://danklinux.com/docs/) shell.

## Use

* `nix run .#write-flake` (re)generate flake.nix (when changing flake inputs).
* `nix flake lock` (re)generate flake.lock.
* `nix flake update` update all flakes in flake.lock.
* `nix flake check` check flake parses correctly.
* `nix run .#<name>` build the `<name>` configuration.
* `nix run .#<name> -- switch` switch to configuration for `<name>`.
* `nix build .#installer-iso` build the offline installer ISO image (output to
`results/iso/nixos-offline-installer.iso`).

## Layout

### `modules/boxen/<name>`

Each box is defined here, loosely following standard NixOS conventions.

* `default.nix`: Denful host declaration.
* `configuration.nix`: Software configuration, including system-wide aspects.
* `hardware.nix`: Hardware definitions, including system-wide aspects.
* `secrets.yaml`: Host-level secrets.
* `tpm.age`: If TPMv2.0 is available, this is the age-plugin-tpm key for the
TPM device to manage the host secrets.
* `ssh_(rsa|ed25519).pub`: If SSH server is configured, this is the RSA/ED25519
public key.

### `modules/users/<name>`

User definitions.  
Mostly using homeManager and independent aspects, but more complex setup can
separate into a system aspect and per-user configuration aspects if needed.

### `modules`

General use aspects.  
Aspects should generally be kept to a single file, named `<aspect-name>.nix`.  
Aspects that need to include larger scripts or additional definitions get
sub-directories, named `<aspect-name>/default.nix`.

## Special cases

### `modules/installer-iso.nix`

Creates and offline installer ISO image for all boxen defined in this repo.
It does so by creating a target `nixosConfiguration` itself, then collecting
all the outputs of all the other `nixosConfigurations` and dependencies into a
single closure. That closure is added to the system and thus all outputs from
all systems become available in the `installer` system.  Then each box gets a
simple wrapper script to call `disk-install` with the specific target install
disk.  
Once built, write it to a USB device (`dd if=result/iso/nixos-offline-installer.iso
bs=4M status=progress oflag=sync of=/dev/<usb-device>`), boot from it, then run
`install-<box-name>`.
