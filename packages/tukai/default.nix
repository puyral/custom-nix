{rustPlatform, lib, fetchFromGitHub, ...}:

  let 
    src = fetchFromGitHub {
      owner = "hlsxx";
      repo = "tukai";
      rev = "v0.2.2";
      hash = "sha256-6CQ0WBVqrEQxIccLO2Z1c3r68c5LsrSHgYuDx2IW8kI=";
    };
    manifest = (lib.importTOML"${src}/Cargo.toml").package;
  
  in
rustPlatform.buildRustPackage {
        name = manifest.name;
        version = manifest.version;
        cargoLock.lockFile = "${src}/Cargo.lock";
        src = lib.cleanSource src;
      }