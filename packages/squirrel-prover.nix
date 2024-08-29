{ pkgs, opam-nix, system, squirrel-prover-src, ... }: {
  packages = {
    squirrel-prover = let
      src = squirrel-prover-src;
      inherit (opam-nix.lib.${system}) buildOpamProject;
      scope = buildOpamProject { } "squirrel" src {
        yojson = "*";
        ppx_yojson_conv = "*";
        why3 = "*";
      };
    in scope.squirrel;
  };
}
