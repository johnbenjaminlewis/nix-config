.PHONY: init
init:
	./bin/install.sh

.PHONY: build
build:
	sudo darwin-rebuild switch --flake .

.PHONY: format
format:
	nix fmt .
