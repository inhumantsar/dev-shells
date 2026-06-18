# dev-shells

Reusable Nix dev shells defined as composable attribute sets.

## Structure

- **`flake.nix`** — flake entry point; defines `mergeShells`, calls `pkgs.mkShell`
- **`bevy.nix`** — Bevy-specific library deps + `LD_LIBRARY_PATH`; imports `rust.nix` internally
- **`rust.nix`** — Rust toolchain (rust-bin, sccache, cargo-llvm-cov)
- **`opencode.nix`** — Standalone opencode FHS environment with plugins
- **`nix.nix`** — Nix tooling (nixd, nixfmt, nil, nom, nix-tree)
- **`typescript.nix`** — TypeScript tooling (bun, nodejs, typescript, typescript-language-server)

Every `.nix` file (except `flake.nix`) returns raw `mkShell` attrs (no `mkShell` call).
`flake.nix` imports, composes via `mergeShells`, and wraps with `pkgs.mkShell`.

## mergeShells

```nix
mergeShells = shells: builtins.foldl' (acc: shell: {
  nativeBuildInputs = (acc.nativeBuildInputs or []) ++ (shell.nativeBuildInputs or []);
  buildInputs       = (acc.buildInputs or []) ++ (shell.buildInputs or []);
  shellHook         = (acc.shellHook or "") + (shell.shellHook or "");
} // (builtins.removeAttrs shell ["nativeBuildInputs" "buildInputs" "shellHook"])) {} shells;
```

Concatenates lists, appends `shellHook`, last-wins for plain attrs.
