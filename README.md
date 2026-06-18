# dev-shells

Reusable [Nix dev shells](https://nixos.wiki/wiki/Development_environment_with_nix-shell)
for a variety of environments — designed to be composed together.

## Available shells

| Shell | Contents |
|---|---|
| `default` | `nix` + `opencode` |
| `bevy` | Bevy library deps + `rust` |
| `rust` | Rust toolchain (rust-bin, sccache, cargo-llvm-cov) |
| `opencode` | opencode FHS env with plugins |
| `nix` | nixd, nixfmt, nil, nix-output-monitor, nix-tree |
| `typescript` | bun, nodejs, typescript, typescript-language-server |

## Usage

Each `.nix` file (except `flake.nix`) is a module. Use `mergeShells` to combine them.

```nix
{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    dev-shells.url = "https://github.com/inhumantsar/dev-shells";
  };

  outputs = { dev-shells, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = dev-shells.lib.overlaysFor system;
      };

      mergeShells = dev-shells.lib.mergeShells;

      rust     = import "${dev-shells}/rust.nix" { inherit pkgs; };
      opencode = import "${dev-shells}/opencode.nix" { inherit pkgs; };
    in {
      devShells.${system}.combined = pkgs.mkShell (mergeShells [
        rust
        opencode
        # add your own packages
        { nativeBuildInputs = with pkgs; [ cmake ]; }
      ]);
    };
}
```

## License

MIT
