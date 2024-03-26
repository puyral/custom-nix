{ pkgs, ... }:
with pkgs;
{
  packages.vampire = vampire.overrideAttrs (finalAttrs: previousAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "vprover";
            repo = "vampire";
            rev = "23d7e9c3b61479bc14e1687f917c22f80dc7c8f1";
            sha256 = "sha256-Aig86q+f+XvQCqJyHqR610+4+mzy+gwAxY6lSdRAvss=";
          };
          version = "master";
          doCheck = false;
          patches = [];
        });
}
