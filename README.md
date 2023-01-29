# Advent of Code

This repo contains my attempts for AOC 2020 - 2022.

## Running the codes

- Running a specific day
```
shards run day01
```

- Running tests
```
crystal spec spec/file_spec.cr
```

or just

```
crystal spec
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
