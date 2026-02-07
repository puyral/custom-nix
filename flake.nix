{
  description = "custom nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    opam-nix = {
      url = "github:tweag/opam-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    isw-src = {
      url = "github:YoyPa/isw";
      flake = false;
    };
    vampire-master-src = {
      url = "github:vprover/vampire";
      flake = false;
    };
    cryptovampire-src = {
      url = "github:SecPriv/CryptoVampire";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    squirrel-prover-src = {
      url = "github:squirrel-prover/squirrel-prover";
      flake = false;
    };

    squirrel-prover-src-cv = {
      url = "github:puyral/squirrel-prover?ref=cryptovampire";
      flake = false;
    };
    rnote-src = {
      url = "github:puyral/rnote/add-block-touch";
      flake = false;
    };
    zfs-inplace-rebalance-src = {
      url = "github:markusressel/zfs-inplace-rebalancing";
      flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      opam-nix,
      treefmt-nix,
      ...
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./fmt.nix;

        pkgs = nixpkgs.legacyPackages.${system};
        args = inputs // {
          system = system;
          pkgs = pkgs;
          custom-packages = mpackages;
        };
        mKpkgs = builtins.foldl' (
          acc: x: acc // ((import (./. + ("/apackages/" + x + ".nix"))) args).packages
        ) { };
        mpackages =
          (mKpkgs [
            "cvc5"
            "clocktui"
            "tclock"
            "enblend-enfuse"
            "hugin"
            "deepsec"
            # "squirrel-prover"
            "vampire"
            "isw"
            "cryptovampire"
            "rnote"
            "zfs-inplace-rebalance"
          ])
          // by_callpkgs;

        by_callpkgs =
          with builtins;
          (
            let
              dir = ./packages;
            in
            mapAttrs (name: _: pkgs.callPackage "${dir}/${name}" args) (readDir dir)
          );

        mkApp =
          with builtins;
          package:
          let
            mapps = package.apps or [ { } ];
            args = map (
              app:
              app
              // rec {
                drv = package;
                name = drv.pname or drv.name;
              }
            ) mapps;
            apps = map (args: {
              name = args.name;
              value = flake-utils.lib.mkApp args;
            }) args;
          in
          listToAttrs apps;
      in
      {
        packages = mpackages;
        # apps = with builtins;
        #   let apps = map mkApp (attrValues mpackages);
        #   in foldl' (acc: x: acc // x) { } apps;

        formatter = treefmtEval.config.build.wrapper;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixd ] ++ lib.optional stdenv.isDarwin git;
        };

      }
    ))
    // {
      templates = {
        base = {
          path = ./templates/base;
          description = "a basic template";
        };
      };
    };
}
