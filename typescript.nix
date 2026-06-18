{ pkgs }:
{
  nativeBuildInputs = with pkgs; [
    bun
    nodejs
    typescript
    typescript-language-server
    biome
    just
  ];
}
