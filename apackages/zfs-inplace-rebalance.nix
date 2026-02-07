{ pkgs, zfs-inplace-rebalance-src, ... }:
{
  packages.zfs-inplace-rebalancing = pkgs.stdenv.mkDerivation rec {
    name = "zfs-inplace-rebalancing"; # Replace with your desired package name
    version = "1.0"; # Replace with your package version

    src = zfs-inplace-rebalance-src; # Assuming your script is in the current directory, adjust as needed

    buildInputs = with pkgs; [
      bash
      perl
      zfs
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${src}/${name}.sh $out/bin/${name}-script # You can rename the script here if needed
      chmod +x $out/bin/${name}
      patchShebangs $out/bin/${name}
    '';
  };

}
