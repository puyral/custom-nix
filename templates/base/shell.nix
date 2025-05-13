{
  pkgs ? import <nixpkgs> { },
  extra ? []
}:

with pkgs;
mkShell {
  buildInputs = [
    nixd
  ] ++ extra;
}