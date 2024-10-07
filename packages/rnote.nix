{ rnote-src, pkgs, ... }: {
  packages = rec {
    rnote = pkgs.rnote.overrideAttrs (finalAttrs: previousAttrs: rec {
      src = rnote-src;
      cargoDeps =
        pkgs.rustPlatform.importCargoLock { lockFile = "${src}/Cargo.lock";outputHashes = {
      "ink-stroke-modeler-rs-0.1.0" = "";
      "piet-0.6.2" = "";
    }; };
    });
  };
}
