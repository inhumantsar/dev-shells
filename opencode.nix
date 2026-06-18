{ pkgs }:
let
  opencode-fhs = pkgs.buildFHSEnv {
    name = "opencode";

    targetPkgs = _: [
      pkgs.bashInteractive
      pkgs.coreutils
      pkgs.gcc.cc.lib
      pkgs.glibc
      pkgs.opencode
      pkgs.nodejs
      pkgs.openssl
      pkgs.zlib
    ];

    runScript = "opencode";
  };
in
{
  nativeBuildInputs = [
    opencode-fhs
    pkgs.codegraph
  ];
}
