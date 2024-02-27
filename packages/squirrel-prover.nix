{ pkgs, opam-nix, system, ... }: {
  packages = rec {
    squirrel-prover = let
      src = pkgs.fetchFromGitHub {
        owner = "squirrel-prover";
        repo = "squirrel-prover";
        rev = "8304f16fa7184c304ead61b1c0bd24a4645ca2b3";
        hash = "sha256-tVMNGNhC1FsJlZEI/9mM+nwms2ZdBjRj0TDf0Zq2qGk=";
      };
      inherit (opam-nix.lib.${system}) buildOpamProject;
      # sq-package = opam-nix.lib.${system}.opam2nix {
      #   src = src;
      #   name = "squirrel";
      # } (with pkgs; { nixpkgs = pkgs; inherit ocaml;});
      scope = buildOpamProject { } "squirrel" src { ocaml-system = "*"; };
    in scope.squirrel;
  };
}
