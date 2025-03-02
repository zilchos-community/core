{ name ? "openrc", stdenv, fetchurl, gnumake, python, ninja, meson, pkg-config, cmake, libcap }:

stdenv.mkDerivation {
  pname = name;
  version = "0.60";

  src = fetchurl {
    url = "https://github.com/OpenRC/openrc/archive/refs/tags/0.60.tar.gz";
    sha256 = "sha256-WVjEC+BnQK3hN1C/aSh4sAxc5Qz+wxGb0uc3jD1lZyU=";
  };

  buildInputs = [ gnumake ];

  configurePhase = ''
    export LD_LIBRARY_PATH=${python}/lib
    export PKG_CONFIG_PATH=${libcap}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PATH=${pkg-config}/bin:${cmake}/bin:${ninja}/bin:$PATH
    ${python}/bin/python3 ${meson}/bin/meson setup \
        -Dos=Linux \
        -Dpam=false \
        -Daudit=disabled \
        -Dselinux=disabled \
    	--bindir $out/bin --libdir $out/lib64 \
        --libexecdir $out/lib --sbindir $out/sbin build
  '';

  buildPhase = ''
  '';

  extraBuildFlags = [
  ];

  installPhase = "mkdir $out/bin -p && cp ninja $out/bin";

  allowedRequisites = [ "out" stdenv.musl ];
  allowedReferences = [ "out" stdenv.musl ];
}
