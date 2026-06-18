{ pkgs }:
{
  nativeBuildInputs = with pkgs; [
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-analyzer"
        "rust-src"
      ];
    })
    sccache # shared compilation cache wrapper
    pkg-config
    openssl
    cargo-llvm-cov
    just
  ];

  RUST_BACKTRACE = 1;
}
