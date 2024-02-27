{
  description = "cvc5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
    opam-nix = { url = "github:tweag/opam-nix"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, opam-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        args = inputs // {
          system = system;
          pkgs = pkgs;
          custom-packages = packages;
        };
        mKpkgs = builtins.foldl' (acc: x:
          acc // ((import (./. + ("/packages/" + x + ".nix"))) args).packages)
          { };
        packages = mKpkgs [
          "cvc5"
          "clocktui"
          "tclock"
          "enblend-enfuse"
          "hugin"
          "deepsec"
          "squirrel-prover"
        ];
      in {
        packages = packages;
        formatter = nixpkgs.legacyPackages.${system}.nixfmt;

        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nil ]; };
      });
}
