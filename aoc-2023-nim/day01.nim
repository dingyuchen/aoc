import std/strutils
import std/sequtils
from sugar import collect

let input = splitlines(stdin.readAll())
let digits = collect(newSeq):
    for line in input.items:
        let digits = collect(newSeq):
            for c in line:
                if isDigit(c):
                    c
        let v = digits[0] & digits[^1]
        parseInt(v)
echo digits.foldl(a + b)
