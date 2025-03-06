{ pkgs, opam-nix, system, squirrel-prover-src, squirrel-prover-src-cv, ... }: {
  packages = rec {
    squirrel-prover = let
      src = squirrel-prover-src;
      inherit (opam-nix.lib.${system}) buildOpamProject;
      scope = buildOpamProject { } "squirrel" src {
        yojson = "*";
        ppx_yojson_conv = "*";
        ocaml-lsp-server = "*";
        why3 = "*";
        ocamlformat = "*";
        # ocaml-system = "4.*";
      };
    in scope.squirrel;
    squirrel-prover-cv =
      squirrel-prover.override { src = squirrel-prover-src-cv; };
  };
}
