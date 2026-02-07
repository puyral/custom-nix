{
  rnote-src,
  pkgs,
  fenix,
  system,
  ...
}:
let
  toolchain = fenix.packages.${system}.stable.toolchain;
  # rustPlatform = pkgs.rustPlatform;
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };

in
{
  packages = rec {
    rnote = pkgs.callPackage ./rnote {
      inherit rustPlatform;
      src = rnote-src;
    };
  };
}
