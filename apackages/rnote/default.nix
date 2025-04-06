# { rnote, rustPlatform, src, ... }:
# rnote.overrideAttrs (finalAttrs: previousAttrs: rec {
#   inherit src;
#   cargoDeps = rustPlatform.importCargoLock {
#     lockFile = "${src}/Cargo.lock";
#     outputHashes = {
#       "ink-stroke-modeler-rs-0.1.0" =
#         "sha256-B6lT6qSOIHxqBpKTE4nO2+Xs9KF7JLVRUHOkYp8Sl+M=";
#       # "piet-0.6.2" = "sha256-o1/MDvE0eHUaebkWbvQ0JRytMjvyvWLRmc2QtEeb+2I=";
#       # "points_on_curve-0.5.0" =
#       #   "sha256-1mmxG8oDdQ3KQtvIPT4TPgz+akdFah0uH6b1oJ4ASD0=";
#     };
#   };
# })

{ lib, stdenv, fetchFromGitHub, alsa-lib, appstream, appstream-glib, cargo
, cmake, desktop-file-utils, dos2unix, glib, gst_all_1, gtk4, libadwaita
, libxml2, meson, ninja, pkg-config, poppler, python3, rustPlatform, rustc
, shared-mime-info, wrapGAppsHook4, src }:

stdenv.mkDerivation rec {
  inherit src;
  pname = "rnote";
  version = "0.11.0";

  # src = fetchFromGitHub {
  #   owner = "flxzt";
  #   repo = "rnote";
  #   rev = "v${version}";
  #   hash = "sha256-RbuEgmly6Mjmx58zOV+tg6Mv5ghCNy/dE5FXYrEXtdg=";
  # };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "ink-stroke-modeler-rs-0.1.0" =
        "sha256-B6lT6qSOIHxqBpKTE4nO2+Xs9KF7JLVRUHOkYp8Sl+M=";
      "poppler-rs-0.24.1"= "sha256-KlMAJa1RBL125qeaLc3aGLFW3WArikMMawtNWdmhhKQ=";
    };
  };

  nativeBuildInputs = [
    appstream-glib # For appstream-util
    cmake
    desktop-file-utils # For update-desktop-database
    dos2unix
    meson
    ninja
    pkg-config
    python3 # For the postinstall script
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  dontUseCmakeConfigure = true;

  mesonFlags = [ (lib.mesonBool "cli" true) ];

  buildInputs =
    [ appstream glib gst_all_1.gstreamer gtk4 libadwaita libxml2 poppler ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  postPatch = ''
    chmod +x build-aux/*.py
    patchShebangs build-aux
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  meta = with lib; {
    homepage = "https://github.com/flxzt/rnote";
    changelog = "https://github.com/flxzt/rnote/releases/tag/${src.rev}";
    description = "Simple drawing application to create handwritten notes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda gepbird yrd ];
    platforms = platforms.unix;
  };
}
