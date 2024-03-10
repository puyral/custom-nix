{ pkgs, ... }:
with pkgs;
if stdenv.isDarwin then {
  packages = { };
} else {
  packages.enblend-enfuse = enblend-enfuse.overrideAttrs
    (finalAttrs: previousAttrs: {

      configureFlags = [ "--enable-openmp=yes" "--enable-opencl=yes" ];

      buildInputs = previousAttrs.buildInputs
        ++ lib.optionals stdenv.isLinux [ ocl-icd ]
        ++ lib.optionals stdenv.cc.isClang llmPacakges.openmp
        ++ [ opencl-headers ];

      apps = [{ name = "enblend"; }];

      # installPhase = ''
      #   install -m0755 -D 
      # ''; V
    });
}
