{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name= "site-max";

  inherit (pkgs) sassc;
  inherit (pkgs) stdenv;

  src = ./.;

  buildPhase = ''
    ${sassc}/bin/sassc -m auto -t compressed scss/creative.scss css/creative.css
  '';

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "Site de présentation de Max Spiegel";
    homepage = https://maxspiegel.fr/;
    maintainers = with stdenv.lib.maintainers; [ nyanloutre ];
    license = stdenv.lib.licenses.cc-by-nc-sa-40;
    platforms = stdenv.lib.platforms.all;
  };
}
