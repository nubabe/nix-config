# Copilot instructions for this repository

Purpose: help Copilot sessions understand how to build, run, and reason about this Nix flake-based configuration repo.

---
1) Build, test, and run commands

- Build the flake root (default outputs):
  - nix build

- Build a NixOS host's toplevel (replace <host>):
  - nix build ".#nixosConfigurations.<host>.config.system.build.toplevel"

- Rebuild a remote host (uses nixos-rebuild via nix run):
  - ./scripts/rebuild.sh <ssh-target>

- Deploy / generate hardware and run installer workflows:
  - ./scripts/deploy.sh <ssh-target> <host-attribute-name>
  - ./scripts/local.sh <host-attribute-name>  # generates hosts/<name>/hardware.nix and git-adds it

- Other helpful one-offs (used by scripts):
  - nix run github:nix-community/nixos-anywhere -- --flake ".#<host>" --extra-files ./extra-files
  - nix run github:nix-community/disko/latest#disko-install -- --flake ".#<host>"

- Tests / lint: none present in this repository (no test runner or linter targets detected).

---
2) High-level architecture (big picture)

- This repository is a Nix flake that composes modular NixOS / darwin / home-manager configurations.
- Root flake (flake.nix) delegates to modules/ via import-tree and flake-parts. The modules/ tree contains three main areas:
  - modules/flake — flake-specific composition (defines how modules are exposed as flake outputs)
  - modules/nixos — reusable NixOS modules (core, services, network, etc.) organized by purpose
  - modules/hosts — host-specific configurations; each host is an attribute (directory) and may be built as a nixosConfiguration
- Hosts/Hardware: host hardware config files are stored at hosts/<hostname>/hardware.nix. Scripts generate and git-add these files during provisioning.
- extra-files/ is passed into installer flows (nixos-anywhere / disko) and used as supplementary files during deploy.

---
3) Key conventions and patterns (repo-specific)

- Host definition pattern
  - Hosts are declared under modules/hosts as attribute directories (e.g., modules/hosts/prv3-10). The flake exposes these via the simpleHosts pattern in modules/flake/hosts.nix.
  - Each host attribute can set: arch (x86_64|aarch64), stateVersion, and a list named modules (deferred modules to import).
  - Hardware is generated to hosts/<name>/hardware.nix and is intentionally committed (scripts run git add).

- Module composition
  - modules/flake/modules.nix collects generic/nixos/darwin/homeManager modules and wires them into flake outputs.
  - Use modules/nixos/* to add feature modules (core.nix, services, network, etc.). These are gateable by options and combined by flake modules.

- Scripts
  - scripts/deploy.sh — runs nixos-anywhere to generate hardware config and deploy (expects: ssh-target, host-name)
  - scripts/rebuild.sh — runs nixos-rebuild on a remote target (expects: ssh-target)
  - scripts/local.sh — helper to capture hardware config locally and to run disko-install

- Flake outputs
  - The flake exposes nixosConfigurations and darwinConfigurations via the simpleHosts mapping; prefer building the explicit toplevel attribute when validating a host build.

---
4) Other AI-assistant / tooling files checked

- No CLAUDE.md, AGENTS.md, CONVENTIONS.md, .cursorrules, .windsurfrules, nor copilot-instructions.md were present prior to creating this file.

---
If more detail is wanted (examples for adding a host, a recommended validation workflow for changes, or explicit attribute names exposed by the flake outputs), say which area to expand and Copilot will add focused guidance.
