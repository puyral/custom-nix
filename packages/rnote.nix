{ rnote-src, pkgs, ... }: {
  packages = rec {
    rnote = pkgs.rnote.overrideAttrs (finalAttrs: previousAttrs: rec {
      src = rnote-src;
      cargoDeps =
        pkgs.rustPlatform.importCargoLock { lockFile = "${src}/Cargo.lock";outputHashes = {
      "ink-stroke-modeler-rs-0.1.0" = "sha256-B6lT6qSOIHxqBpKTE4nO2+Xs9KF7JLVRUHOkYp8Sl+M=";
      "piet-0.6.2" = "sha256-o1/MDvE0eHUaebkWbvQ0JRytMjvyvWLRmc2QtEeb+2I=";
      "points_on_curve-0.5.0" = "sha256-1mmxG8oDdQ3KQtvIPT4TPgz+akdFah0uH6b1oJ4ASD0=";
    }; };
    });
  };
}
