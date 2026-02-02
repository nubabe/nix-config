#!/usr/bin/env bash

echo "You have some time to abort. This script can be dangerous!"
sleep 5

TARGET_HOSTNAME="$1"

nix run 'nixpkgs#nixos-generate-config' \
	--extra-experimental-features "nix-command flakes" \
	-- \
	--no-filesystems
	--show-hardware-config > "./hosts/$TARGET_HOSTNAME/hardware.nix"
git add "./hosts/$TARGET_HOSTNAME/hardware.nix"

nix run github:nix-community/disko/latest#disko-install \
	--extra-experimental-features "nix-command flakes" \
	-- \
	--flake ".#$TARGET_HOSTNAME"
