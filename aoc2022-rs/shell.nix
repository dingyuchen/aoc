with import <nixpkgs> { };

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    rustc
    cargo
    rust-analyzer
  ];
}
