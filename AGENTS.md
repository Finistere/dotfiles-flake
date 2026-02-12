# AGENTS

## Overview
This repo is a Nix flake that defines NixOS and nix-darwin system configurations plus home-manager modules.

## Repository structure
- `flake.nix`: Flake inputs/outputs, system constructors, shared `me` context.
- `machines/`: Per-host configurations.
  - `machines/bach/`, `machines/bruckner/`, `machines/stravinsky/`, `machines/zelenka/`
- `modules/desktop/`: OS-level modules.
  - `common.nix` shared settings
  - `darwin.nix` macOS (nix-darwin) additions
  - `nixos/` NixOS modules (`default.nix`, `kde.nix`, `sound.nix`, `dev.nix`, `gaming.nix`)
- `modules/home/`: Home-manager modules and dotfiles.
  - `terminal/` (git, editor, shell tools)
  - `.aerospace.toml`, `kitty.conf`
- `secrets/`: `agenix` secrets definitions.
- `public-keys.nix`: SSH public keys used for secrets.

## Key entry points
- `flake.nix` defines:
  - `darwinSystem` and `darwinDeterminateSystem` for macOS
  - `nixosSystem` for Linux
  - `me` context (hostName, system, userName, theme, helper lib)
- `machines/<host>/default.nix` imports host-specific hardware and modules.
- `modules/desktop/common.nix` wires home-manager and shared packages.

## Commands (observed)
- Install NixOS from README:
  - `nixos-install --root /mnt --flake ./dotfiles-flake#<machine>`

No build/test/lint commands or CI workflows are present in this repository.

## Conventions and patterns
- Nix modules use `{ pkgs, me, inputs, ... }:` style arguments.
- The shared `me` context (from `flake.nix`) provides:
  - `hostName`, `system`, `userName`, `theme`
  - `lib.matchOs`, `lib.ifLinuxOr`, `lib.ifDarwinOr`
- Home-manager modules are imported via `modules/desktop/common.nix`.
- Home-manager dotfiles are managed with `home.file` entries.

## Secrets and keys
- `secrets/secrets.nix` defines age secrets and uses keys from `public-keys.nix`.
- `flake.nix` enables `agenix` for both NixOS and nix-darwin.
- `machines/zelenka/default.nix` disables `nix` (Determinate System installer note).

## OS-specific notes
- macOS settings and Homebrew packages are in `modules/desktop/darwin.nix`.
- NixOS desktop stack lives in `modules/desktop/nixos/` (KDE, PipeWire, gaming, dev).
- `modules/home/.aerospace.toml` is copied to `~/.aerospace.toml` on macOS via home-manager.
