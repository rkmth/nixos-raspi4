# nixos-raspi4

## Preparing Macos for remote compilation

1. Install nix:

```bash

    curl -L https://nixos.org/nix/install | sh
```

1. Enable experimental features in your Nix configuration `(~/.config/nix/nix.conf)`:

```bash

    experimental-features = nix-command flakes
```

1. Building the Image

```bash

    nix build --extra-experimental-features nix-command --extra-experimental-features flakes .#packages.aarch64-linux.sdcard
```
