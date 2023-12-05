.PHONY: help
help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build-%: ## Builds the NixOS system for a given box
	sudo -E nixos-rebuild switch --flake .#$*

.PHONY: rehome
rehome-%: ## Uses home-manager to reconfigure the home env
	home-manager switch --flake .#$*

.PHONY: iso
iso-%:  ## Builds a minimal installer ISO for a given box
	nix build .#iso-$*
