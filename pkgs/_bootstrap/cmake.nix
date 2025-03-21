{ name ? "cmake", fetchurl, mkDerivation
, toolchain, busybox, gnumake, linux-headers} :

let
  source-tarball-cmake = fetchurl {
    # local = /downloads/cmake-3.27.4.tar.gz;
    url = "https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz";
    sha256 = "0a905ca8635ca81aa152e123bdde7e54cbe764fdd9a70d62af44cad8b92967af";
  };
in
  mkDerivation {
    inherit name;
    buildInputs = [ toolchain busybox gnumake ];
    script = ''
        export SHELL=${busybox}/bin/ash
      # unpack:
        unpack ${source-tarball-cmake}
      # fixup:
        sed -i 's|/bin/sh|${busybox}/bin/ash|' bootstrap
      # bundle libraries:
        # poor man's static linking, a way for cmake to be self-contained later
        mkdir -p $out/bundled-runtime
        cp -H ${toolchain}/sysroot/lib/*.so* $out/bundled-runtime/
      # configure:
        ash configure \
          CFLAGS="-DCPU_SETSIZE=128 -D_GNU_SOURCE -I${toolchain}/lib/clang/17/include" \
          CXXFLAGS="-isystem ${linux-headers}/include" \
          LDFLAGS="-Wl,-rpath $out/bundled-runtime" \
          --prefix=$out \
          --parallel=$NPROC \
          -- \
          -DCMAKE_USE_OPENSSL=OFF
      # build:
        make SHELL=$SHELL -j $NPROC
      # install:
        make SHELL=$SHELL -j $NPROC install/strip
    '';
  }
