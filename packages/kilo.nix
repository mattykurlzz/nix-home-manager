# Kilo CLI packaged for Home Manager (final Step 6 migration target).
#
# STATUS: SCAFFOLD. Not yet imported into `home.packages` (it must resolve sha256 first).
# To finish wiring (run in the repo, in a shell where you can see hex):
#   nix flake prefetch-url 'https://registry.npmjs.org/@kilocode/cli/-/cli-<version>.tgz'
# put that hash into `sha256` below, add `imports/packages` into configuration/work,
# then `home-manager switch`.
#
# @kilocode/cli is an npm CLI. If it declares required deps they must be either bundled
# in the tarball or added to `buildInputs`. Verify with `npm view @kilocode/cli@version dependencies`.

{ pkgs, lib, fetchurl }:

let
  version = "7.8.27"; # match the currently installed npm version
in
pkgs.stdenv.mkDerivation {
  pname = "kilocode-cli";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@kilocode/cli/-/cli-${version}.tgz";
    sha256 = ""; # FILL ME: `nix flake prefetch-url <url>`
  };

  buildInputs = [ pkgs.nodejs ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/@kilocode $out/bin
    tar xzf $src -C $out/lib/node_modules/@kilocode
    mv $out/lib/node_modules/@kilocode/package $out/lib/node_modules/@kilocode/cli
    ln -s $out/lib/node_modules/@kilocode/cli/bin/* $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Kilo programming CLI (migrated from npm global)";
    homepage = "https://kilo.ai";
    license = licenses.unfreeRedistributable;
  };
}