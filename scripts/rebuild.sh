#!/usr/bin/env bash

TARGET_HOST="$1"

nix run nixpkgs#nixos-rebuild -- \
	--flake ".#$TARGET_HOST" \
	--target-host "$TARGET_HOST" \
	--sudo \
	--ask-sudo-password \
	switch
