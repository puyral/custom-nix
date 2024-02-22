{ pkgs, custom-packages, ... }:
with pkgs; {
  packages.hugin =
    hugin.override { enblend-enfuse = custom-packages.enblend-enfuse; };
}
