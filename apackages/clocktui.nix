{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "IsaacTay";
    repo = "clocktui";
    rev = "720f1b762ca75243768ea66aae21ca5de2d5f543";
    hash = "sha256-B04goFf6xFVEcInOQEhGJFruql2FF3F3vcxUljOvNfU=";
  };
  manifest = (pkgs.lib.importTOML "${src}/Cargo.toml").package;
in {
  packages.clocktui = pkgs.rustPlatform.buildRustPackage {
    name = manifest.name;
    version = manifest.version;
    cargoLock.lockFile = "${src}/Cargo.lock";
    src = pkgs.lib.cleanSource src;
  };
}
