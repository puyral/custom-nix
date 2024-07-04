{ pkgs, ... }:
with pkgs;
let
  mkvampire = version: src:
    vampire.overrideAttrs (finalAttrs: previousAttrs: {
      inherit version src;
      doCheck = false;
      patches = [ ];
    });

in {
  packages = rec {
    vampire = vampire-master;

    vampire-master = mkvampire "master" (fetchFromGitHub {
      owner = "vprover";
      repo = "vampire";
      rev = "5ad494e781908ce0661b28c9ca39d8c1e7f0918c";
      hash = "sha256-NHAlPIy33u+TRmTuFoLRlPCvi3g62ilTfJ0wleboMNU=";
    });

    vampire-ccsa = mkvampire "ccsa" (fetchFromGitHub {
      owner = "vprover";
      repo = "vampire";
      rev = "8a4dba9";
      hash = "sha256-VIFQykbpa0PqdZUgm9Y+r5Xt9z6h0Tzigq1hPckKwmc=";
    });
  };

  # see `nurl` to get the fetchfromgithub commands
}
