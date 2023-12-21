open Aoc_2023

let num_words = [ "one"; "two"; "three"; "four"; "five"; "six"; "seven"; "eight"; "nine" ]
let range n = List.init n (fun x -> x)

let calibration_values =
  let lines = Stdin.read_file "inputs/day01.txt" in
  let find_first line =
    let index =
      List.find_index (fun num_word -> String.starts_with ~prefix:num_word line) num_words
    in
    match index with
    | Some i -> i + 1
    | None -> -1
  in
  let parse_i line =
    let c = line.[0] in
    match c with
    | '1' -> 1
    | '2' -> 2
    | '3' -> 3
    | '4' -> 4
    | '5' -> 5
    | '6' -> 6
    | '7' -> 7
    | '8' -> 8
    | '9' -> 9
    | '0' -> 0
    | _ -> find_first line
  in
  let parse line =
    let l = String.length line in
    let matches = List.map (fun start -> String.sub line start (l - start)) (range l) in
    let nums = List.map parse_i matches |> List.filter (fun num -> num >= 0) in
    (List.hd nums * 10) + List.nth nums (List.length nums - 1)
  in
  List.map parse lines
;;

let () =
  List.fold_left (fun acc x -> acc + x) 0 calibration_values
  |> string_of_int
  |> print_endline
;;
