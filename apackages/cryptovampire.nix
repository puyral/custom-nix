{ cryptovampire-src, system, ... }:
{
  packages.cryptovampire = cryptovampire-src.packages.${system}.cryptovampire;
}
