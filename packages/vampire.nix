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
      rev = "1b080631257a403681d1287f87f8d3ac1ee97c63";
      hash = "sha256-7N2L1embD+ZMJDJkzLwledwKp9g4xmHsyIwDchGls1Q=";
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
