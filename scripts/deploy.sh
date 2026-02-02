#!/usr/bin/env bash

TARGET_HOST="$1"
TARGET_HOSTNAME="$2"

echo '{}' > "./hosts/$TARGET_HOSTNAME/hardware.nix"
git add "./hosts/$TARGET_HOSTNAME/hardware.nix"

nix run github:nix-community/nixos-anywhere \
	--extra-experimental-features "nix-command flakes" \
	-- \
	--generate-hardware-config nixos-generate-config "./hosts/$TARGET_HOSTNAME/hardware.nix" \
	--flake ".#$TARGET_HOSTNAME" \
	--target-host "$TARGET_HOST" \
	--extra-files ./extra-files
