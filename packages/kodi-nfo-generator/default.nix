{
  python3Packages,
  kodi-nfo-generator-src,
  lib,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "kodi-nfo-generator";
  version = "0.0.19";

  src = kodi-nfo-generator-src;

  pyproject = true;
  build-system = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    beautifulsoup4
  ];

  doCheck = false;

  meta = with lib; {
    description = "Simple Python-based command-line tool to generate .nfo files for movies and TV shows for Kodi.";
    homepage = "https://github.com/fracpete/kodi-nfo-generator";
    license = licenses.gpl3;
    mainProgram = "kodi-nfo-gen";
  };
}
