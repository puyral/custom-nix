{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    custom = {
      url = "github:puyral/custom-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      treefmt-nix,
      custom,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        cpkgs = custom.legacyPackages.${system};
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./fmt.nix;
        src = ./.;
      in
      {
        devShells.default = pkgs.callPackage ./shell.nix {
          extra = pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.git;
        };
        formatter = treefmtEval.config.build.wrapper;
      }
    );
}
