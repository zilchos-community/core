{ name ? "libcap", stdenv, fetchurl, gnumake }:

stdenv.mkDerivation {
  pname = name;
  version = "2.70";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.70.tar.gz";
    sha256 = "sha256-07d37UE8n6/6zgO5F+FxhUcJteS+ONv7khmq99/U7qY=";
  };

  buildInputs = [ gnumake ];

  configurePhase = "";

  buildPhase = ''
    sed -i '69s/gcc/cc/g' Make.Rules
    CC=clang BUILD_CC=clang make -C libcap all
  '';

  installPhase = ''
    CC=clang BUILD_CC=clang make -C libcap install INCDIR=$out/include LIBDIR=$out/lib
  '';

  allowedRequisites = [ "out" stdenv.musl ];
  allowedReferences = [ "out" stdenv.musl ];
}
