.PHONY: help
help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Installs NixOS for a given box config
ifndef BOX
	@echo "You must define BOX to install (see './boxen/' for options)."
else
	sudo nix run github:nix-community/disko -- --mode disko boxen/$(BOX)/disko.nix
	sudo nixos-install --no-root-passwd --flake .#$(BOX)
endif
