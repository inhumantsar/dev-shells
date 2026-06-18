{ pkgs }:
{
  nativeBuildInputs = with pkgs; [
    nixd
    nixfmt
    nix-output-monitor
    nix-tree
    nil
    just
  ];
}
