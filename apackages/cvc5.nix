{ pkgs, ... }:
let
  rev = "5ff52da72ed2b0299f855828d70b3470c188f8b4";
  hash = "sha256-jyQJ3jI0swJFX/uK4IVc0Pb4jbV3Tc+rm6VpGqGkEYU=";

  pythonic_api = pkgs.fetchFromGitHub {
    owner = "cvc5";
    repo = "cvc5_pythonic_api";
    rev = "c1c83ba39e1526c87051b64f12ebffc29ffd2850";
    hash = "sha256-/vM5NN8B6zfd/o2l7jtR3fXWtBt3KOT/GtAPJE+9V7s=";
  };
in {
  packages = rec {
    cvc5 = pkgs.cvc5.overrideAttrs (finalAttrs: previousAttrs: {
      version = builtins.substring 0 5 rev;
      src = pkgs.fetchFromGitHub {
        owner = "cvc5";
        repo = "cvc5";
        inherit rev hash;
      };

      buildInputs = with pkgs; [
        cadical.dev
        symfpu
        gmp
        gtest
        libantlr3c
        antlr3_4
        boost
        jdk
        (python3.withPackages (ps:
          with ps; [
            pyparsing
            tomli
            scikit-build
            setuptools
            cython
            pytest
          ]))
      ];

      cmakeFlags = previousAttrs.cmakeFlags
        ++ [ "-DBUILD_BINDINGS_PYTHON=ON" "-DPYTHONIC_PATH=${pythonic_api}" ];
    });

    # cvc5-python = ps: (ps.toPythonModule cvc5).python;
  };
}
