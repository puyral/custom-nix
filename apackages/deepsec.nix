{ pkgs, ... }:
{
  packages = rec {
    deepsec = pkgs.stdenv.mkDerivation rec {
      pname = "deepsec";
      version = "2.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "DeepSec-prover";
        repo = "deepsec";
        rev = version;
        hash = "sha256-adjDnvxhTeKRq1P14dC77zjhmCLVLkGMc4RzIgnR/Zo=";
      };
      nativeBuildInputs = with pkgs.ocamlPackages; [
        ocaml
        findlib
        ocamlbuild
      ];
      installPhase = ''
        runHook preInstall
        install -D -t $out/bin deepsec deepsec_api deepsec_worker
        runHook postInstall
      '';
    };

    # deepsec-ui = pkgs.buildNpmPackage rec {
    #   pname = "deepsec-ui";
    #   version = "v1.0.0-rc3";

    #   src = pkgs.fetchFromGitHub {
    #     owner = "DeepSec-prover";
    #     repo = "deepsec_ui";
    #     rev = version;
    #     hash = "sha256-mSxVNHqiXKwWUTBdhu7KArK2PtEmy4KTrHUYvyXq9XY=";
    #   };
    #   buildInputs = [ deepsec ];
    #   nativeBuildInputs = with pkgs; [ electron ];
    #   npmDepsHash = "sha256-nf/vbvhlEas4aBQcwYKYofmovc4Zf4ngyfCgqnI6Lsw=";
    #   dontNpmBuild = true;
    #   env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    #   # The node_modules/XXX is such that XXX is the "name" in package.json
    #   # The path might differ, for instance in electron-forge you need build/main/main.js
    #   postInstall = ''
    #     makeWrapper ${pkgs.electron}/bin/electron $out/bin/${pname} \
    #       --add-flags $out/lib/node_modules/${pname}/main.js
    #   '';
    #   # installPhase = ''
    #   #   runHook preInstall
    #   #   npm run electron:build
    #   #   runHook postInstall
    #   # '';
    # };
  };
}
