.PHONY: help
help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install-%: ## Installs NixOS for a given box
	sudo -E nix run github:nix-community/disko -- --mode disko boxen/$@/disko.nix
	sudo -E nixos-install --no-root-passwd --flake .#$*

.PHONY: build
build-%: ## Builds the NixOS system for a given box
	sudo -E nixos-rebuild switch --flake .#$*

.PHONY: rehome
rehome-%: ## Uses home-manager to reconfigure the home env
	home-manager switch --flake .#$*
