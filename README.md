# Advent of Code

This repo contains my attempts for AOC 2021. (for now)

## Trying out for yourself

The development environment is setup with `nix` and the main language of choice (for 2021) is `Haskell`.

In the project root, start a nix-shell with 

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
