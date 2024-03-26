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
          custom-packages = mpackages;
        };
        mKpkgs = builtins.foldl' (acc: x:
          acc // ((import (./. + ("/packages/" + x + ".nix"))) args).packages)
          { };
        mpackages = mKpkgs [
          "cvc5"
          "clocktui"
          "tclock"
          "enblend-enfuse"
          "hugin"
          "deepsec"
          "squirrel-prover"
          "vampire"
        ];

        mkApp = with builtins;
          package:
          let
            mapps = package.apps or [ { } ];
            args = map (app:
              app // rec {
                drv = package;
                name = drv.pname or drv.name;
              }) mapps;
            apps = map (args: {
              name = args.name;
              value = flake-utils.lib.mkApp args;
            }) args;
          in listToAttrs apps;
      in {
        packages = mpackages;
        # apps = with builtins;
        #   let apps = map mkApp (attrValues mpackages);
        #   in foldl' (acc: x: acc // x) { } apps;

        formatter = nixpkgs.legacyPackages.${system}.nixfmt;

        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nil ]; };
      });
}
