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
      rev = "23d7e9c3b61479bc14e1687f917c22f80dc7c8f1";
      hash = "sha256-Aig86q+f+XvQCqJyHqR610+4+mzy+gwAxY6lSdRAvss=";
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
