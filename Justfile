check:
    nix flake check

fmt:
    nix fmt

update:
    nix flake update

dev:
    nix develop

dev-bevy:
    nix develop .#bevy

dev-rust:
    nix develop .#rust

dev-opencode:
    nix develop .#opencode
