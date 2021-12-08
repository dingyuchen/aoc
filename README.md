# Advent of Code

This repo contains my attempts for AOC 2020 - 2022.

## Running the codes

The development environment is setup with `nix` and the main language of choice (for 2022) is `Rust`.

> I have not figured out how to perform ELF patching for nix's `mkShell` at the moment.
> You will need to have `cargo` installed

I have set up a cargo project for each individual day.

`cd` into the day folder, run

```
cat input.in | cargo run
```

### Running the codes (2021 & 2020)

`cd` into the year folder, and start a nix-shell with

```
nix-shell
```

Open your editor of choice (Vscode for me) in the nix-shell

```
code .
```
This will give the editor access to the GHC and the Haskell language server.

All sample inputs are stored in `test.in` and the full input in `input.in`.

Compile and run Haskell programs with `runhaskell` and pipe the input with stdin.

```
runhaskell filename.hs < test.in
```
