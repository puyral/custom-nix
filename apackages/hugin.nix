{ pkgs, custom-packages, ... }:
with pkgs;
if stdenv.isDarwin then
  {
    packages = { };
  }
else
  {
    packages.hugin = hugin.override { enblend-enfuse = custom-packages.enblend-enfuse; };
  }
