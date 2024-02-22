{ pkgs, ... }:
with pkgs; {
  packages.enblend-enfuse = enblend-enfuse.overrideAttrs
    (finalAttrs: previousAttrs: {

      configureFlags = [ "--enable-openmp=yes" "--enable-opencl=yes" ];

      buildInputs = previousAttrs.buildInputs
        ++ lib.optionals stdenv.isLinux [ ocl-icd ]
        ++ lib.optionals stdenv.cc.isClang llmPacakges.openmp
        ++ [ opencl-headers ];
    });
}
