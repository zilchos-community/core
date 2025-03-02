{ name ? "ninja", stdenv, fetchurl, gnumake, python }:

stdenv.mkDerivation {
  pname = name;
  version = "1.12.1";

  src = fetchurl {
    url = "https://github.com/ninja-build/ninja/archive/refs/tags/v1.12.1.tar.gz";
    sha256 = "sha256-ghvf9Io/aDvEuztvC1/nstZHz2XVKutjMoyRpsbfKFo=";
  };

  buildInputs = [ gnumake ];

  configurePhase = ''
    export LD_LIBRARY_PATH=${python}/lib
    sed -i '702s/^/#/g' ./configure.py
    tail -n 10 ./configure.py
    ${python}/bin/python3 ./configure.py --bootstrap
  '';

  buildPhase = ''
    export LD_LIBRARY_PATH=${python}/lib
    ${python}/bin/python3 ./configure.py
  '';

  installPhase = "mkdir $out/bin -p && cp ninja $out/bin";

  allowedRequisites = [ "out" stdenv.musl ];
  allowedReferences = [ "out" stdenv.musl ];
}
