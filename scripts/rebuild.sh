#!/usr/bin/env bash

TARGET_HOST="$1"

nix run nixpkgs#nixos-rebuild -- \
	--flake "." \
	--target-host "$TARGET_HOST" \
	--sudo \
	--ask-sudo-password \
	switch
