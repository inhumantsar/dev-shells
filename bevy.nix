{ pkgs }:
let
  mergeShells =
    shells:
    builtins.foldl' (
      acc: shell:
      {
        nativeBuildInputs = (acc.nativeBuildInputs or [ ]) ++ (shell.nativeBuildInputs or [ ]);
        buildInputs = (acc.buildInputs or [ ]) ++ (shell.buildInputs or [ ]);
        shellHook = (acc.shellHook or "") + (shell.shellHook or "");
      }
      // (builtins.removeAttrs shell [
        "nativeBuildInputs"
        "buildInputs"
        "shellHook"
      ])
    ) { } shells;

  bevy_deps = with pkgs; [
    openssl
    alsa-lib
    udev
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
    libGL
    vulkan-loader
    vulkan-headers
    kdePackages.wayland.dev
    kdePackages.wayland.out
    wayland
  ];

  bevyAttrs = {
    nativeBuildInputs =
      bevy_deps
      ++ (with pkgs; [
        pkg-config
      ]);

    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath bevy_deps;
  };

  rustAttrs = import ./rust.nix { inherit pkgs; };
in
mergeShells [
  bevyAttrs
  rustAttrs
]
