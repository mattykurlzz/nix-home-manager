# Kilo programming CLI packaged for Home Manager (final Step 6/7 migration target).
#
# @kilocode/cli on npm is a thin wrapper that, at postinstall time, resolves the
# self-contained platform binary package (@kilocode/cli-linux-x64 for glibc x86-64
# with AVX2) and copies it next to its resources. Rather than reimplement that
# wrapper logic, we package the self-contained platform package directly: it ships
# the native `bin/kilo` binary and all runtime resources (console/, tree-sitter/,
# licenses/, bwrap, sandbox worker) co-located, so RESOLUTION RELATIVE TO ITSELF works.
#
# CPU on this host supports AVX2 (checked via /proc/cpuinfo), so non-baseline
# `cli-linux-x64` is the correct variant. If building for a non-AVX2 or musl host,
# swap URL/hash to cli-linux-x64-baseline or cli-linux-x64-musl respectively.
#
# NOTE: this binary is dynamically linked against the HOST system libc and expects
# its loader at /lib64/ld-linux-x86-64.so.2 (as the npm copy does). autoPatchelfHook
# must NOT be used: rewriting the interpreter to the Nix glibc makes it segfault on
# exec. It is a self-contained app; on a glibc Linux host it runs via the system
# runtime exactly like the npm-global install did.
#
# Refresh hash with:
#   nix-prefetch-url 'https://registry.npmjs.org/@kilocode/cli-linux-x64/-/cli-linux-x64-<version>.tgz'

{ pkgs, lib, fetchurl }:

let
  version = "7.8.27";
in
pkgs.stdenv.mkDerivation {
  pname = "kilocode-cli";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@kilocode/cli-linux-x64/-/cli-linux-x64-${version}.tgz";
    sha256 = "02yfwfdvnw5f0kkl1i3msc6pdzffxgf0pq8sksy9l93gk7q5r9qx";
  };

  dontStrip = true;
  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/kilocode $out/bin
    # `bin` already contains kilo + all co-located resources; keep layout.
    cp -r bin/. $out/libexec/kilocode/
    ln -s "$out/libexec/kilocode/kilo" "$out/bin/kilo"
    ln -s "$out/libexec/kilocode/kilo" "$out/bin/kilocode"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Kilo programming CLI (migrated from npm global)";
    homepage = "https://kilo.ai";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "kilo";
  };
}