{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "race604";
    repo = "clock-tui";
    rev = "f616555fa2e0019eb0099f393f068167d4a97f82";
    hash = "sha256-03e+dAPQKsBa33mVO9C8Z2vZZS5/fdVZsqhkMWZZNPA=";
  };
  path = "${src}/clock-tui";
  manifest = (pkgs.lib.importTOML "${path}/Cargo.toml");
in {
  packages = builtins.listToAttrs (builtins.map ({ name, ... }: {
    name = name;
    value = pkgs.rustPlatform.buildRustPackage {
      name = name;
      version = manifest.package.version;
      cargoLock.lockFile = "${src}/Cargo.lock";
      src = pkgs.lib.cleanSource src;
    };
  }) manifest.bin);
}
