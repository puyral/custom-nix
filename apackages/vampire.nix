{ pkgs, vampire-master-src, ... }:
with pkgs;
let
  mkvampire =
    version: src:
    vampire.overrideAttrs (
      finalAttrs: previousAttrs: {
        inherit version src;
        doCheck = false;
        patches = [ ];
      }
    );

in
{
  packages = rec {
    vampire = pkgs.vampire.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "4.9casc2024";
        doCheck = true;
        src = fetchFromGitHub {
          owner = "vprover";
          repo = "vampire";
          rev = "v4.9casc2024";
          hash = "sha256-NHAlPIy33u+TRmTuFoLRlPCvi3g62ilTfJ0wleboMNU=";
        };
        z3 = pkgs.z3.overrideAttrs (
          finalAttrs: previousAttrs: {
            src = fetchFromGitHub {
              owner = "Z3Prover";
              repo = "z3";
              rev = "79bbbf76d0c123481c8ca05cd3a98939270074d3";
              sha256 = "sha256-5npD0gxGDHkGdB54Oqgt7Fpd1vQsaaNUNOuLAAcLbrg=";
            };
            version = "4.12.3-vampire";
            # doCheck = false;
          }
        );
        patches = [ ];
      }
    );

    vampire-master = mkvampire "master" vampire-master-src;

    vampire-ccsa = mkvampire "ccsa" (fetchFromGitHub {
      owner = "vprover";
      repo = "vampire";
      rev = "8a4dba9";
      hash = "sha256-VIFQykbpa0PqdZUgm9Y+r5Xt9z6h0Tzigq1hPckKwmc=";
    });
    vampire-official = pkgs.callPackage ./vampire/vampire.nix { };
  };

  # see `nurl` to get the fetchfromgithub commands
}
