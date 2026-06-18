{
  description = "Agency";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      flake-utils,
      llm-agents,
      nixpkgs,
      rust-overlay,
      ...
    }:
    let
      overlaysFor = system: [
        (import rust-overlay)
        (final: prev: {
          opencode = llm-agents.packages.${system}.opencode;
          codegraph = llm-agents.packages.${system}.codegraph;
        })
      ];

      mergeShells =
        shells:
        builtins.foldl' (
          acc: shell:
          {
            nativeBuildInputs = (acc.nativeBuildInputs or [ ]) ++ (shell.nativeBuildInputs or [ ]);
            buildInputs = (acc.buildInputs or [ ]) ++ (shell.buildInputs or [ ]);
            shellHook = (acc.shellHook or "") + (shell.shellHook or "");
          }
          // (removeAttrs shell [
            "nativeBuildInputs"
            "buildInputs"
            "shellHook"
          ])
        ) { } shells;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = overlaysFor system;
        pkgs = import nixpkgs { inherit system overlays; };

        bevyAttrs = import ./bevy.nix { inherit pkgs; };
        rustAttrs = import ./rust.nix { inherit pkgs; };
        opencodeAttrs = import ./opencode.nix { inherit pkgs; };
        nixAttrs = import ./nix.nix { inherit pkgs; };
        typescriptAttrs = import ./typescript.nix { inherit pkgs; };
      in
      {
        devShells.bevy = pkgs.mkShell bevyAttrs;
        devShells.rust = pkgs.mkShell rustAttrs;
        devShells.opencode = pkgs.mkShell opencodeAttrs;
        devShells.nix = pkgs.mkShell nixAttrs;
        devShells.typescript = pkgs.mkShell typescriptAttrs;
        devShells.default = pkgs.mkShell (mergeShells [
          nixAttrs
          opencodeAttrs
        ]);
        formatter = pkgs.nixfmt;
      }
    )
    // {
      lib = { inherit mergeShells overlaysFor; };
    };
}
