with import <nixpkgs> {};

pkgs.mkShell {
  nativeBuildInputs = [
    ghc
    haskell-language-server
  ];
}
