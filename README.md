# Nix configuration

## Installation

```sh
# detect hardware, etc... follow the nix proceedure initially

# Had to download it locally to make it work
git clone https://github.com/Finistere/dotfiles-flake.git

nixos-install --root /mnt --flake ./dotfiles-flake#<machine>
```
