{ stdenv, fetchurl, lib, buildPackages }:

stdenv.mkDerivation rec {
  pname = "teamredminer";
  version = "0.10.21";

  src = fetchurl {
    url = "https://github.com/todxx/teamredminer/releases/download/v${version}/teamredminer-v${version}-linux.tgz";
    sha256 = "3d5987bba0125150cbb47c49b5929ea579dca1ac3cae4b7a70e96c2c5f843836";
  };

  buildInputs = [ buildPackages.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
    wrapProgram $out/bin/teamredminer --set PATH ${lib.makeBinPath [ stdenv.cc ]}:\$PATH
  '';

  meta = with lib; {
    description = "High-performance AMD GPU miner for a variety of algorithms";
    homepage = "https://github.com/todxx/teamredminer";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
