{
  description = "cvc5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        args = inputs // { pkgs = pkgs; };
        mKpkgs = builtins.foldl' (acc: x:
          acc // ((import (./. + ("/packages/" + x + ".nix"))) args).packages)
          { };
      in {
        packages = mKpkgs [ "cvc5" "clocktui" "tclock" ];
        formatter = nixpkgs.legacyPackages.${system}.nixfmt;

        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nil ]; };
      });
}
