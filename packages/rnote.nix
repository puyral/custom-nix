{ rnote-src, pkgs, ... }: {
  packages = rec {
    rnote = pkgs.rnote.overrideAttrs
      (finalAttrs: previousAttrs: { src = rnote-src; });
  };
}
