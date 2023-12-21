open Aoc_2023

let num_words =
  [ "one"; "two"; "three"; "four"; "five"; "six"; "seven"; "eight"; "nine" ]

let _ =
  let lines = Stdin.read_file "inputs/day01.txt" in
  let find_first line =
    let index =
      List.find_index
        (fun num_word -> String.starts_with ~prefix:num_word line)
        num_words
    in
    match index with Some i -> i + 1 | None -> 0
  in
  let find line = int_of_string (find_first line ^ find_last line) in
  List.map find lines
