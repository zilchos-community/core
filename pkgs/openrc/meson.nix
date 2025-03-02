{ name ? "meson", stdenv, fetchurl, python }:

stdenv.mkDerivation {
  pname = name;
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/mesonbuild/meson/releases/download/1.7.0/meson-1.7.0.tar.gz";
    sha256 = "sha256-CO++hIA+7Qf4Y7BQktZTqdNI9wOHYdkAQS/d9W3rAoQ=";
  };

  configurePhase ="";
  buildPhase ="";

  installPhase = ''
    export LD_LIBRARY_PATH=${python}/lib
    mkdir $out/bin -p
    sed -i '84s/^/#/g' ./mesonbuild/mesonmain.py
    sed -i '85s/^/#/g' ./mesonbuild/mesonmain.py
    sed -i 's/mdist,//g' ./mesonbuild/mesonmain.py
    ${python}/bin/python3 ./packaging/create_zipapp.py --outfile $out/bin/meson --interpreter '/usr/bin/env python3'
  '';

  fixupPhase = ''
  '';
}
