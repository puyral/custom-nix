{ rnote-src, pkgs, ... }: {
  packages = rec {
    rnote = pkgs.rnote.overrideAttrs (finalAttrs: previousAttrs: rec {
      src = rnote-src;
      cargoDeps =
        pkgs.rustPlatform.importCargoLock { lockFile = "${src}/Cargo.lock"; };
    });
  };
}
