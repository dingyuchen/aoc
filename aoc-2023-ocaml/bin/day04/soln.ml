open Aoc_2023

type card =
  { _id : int
  ; winning : int list
  ; have : int list
  }

let parse_card str = String.split_on_char ' ' str |> List.rev |> List.hd |> int_of_string

let int_list_of_string str =
  String.trim str |> String.split_on_char ' ' |> List.filter_map int_of_string_opt
;;

let parse_nums str =
  match String.split_on_char '|' str with
  | [ a; b ] -> int_list_of_string a, int_list_of_string b
  | _ -> failwith "invalid format"
;;

let parse_line line =
  match String.split_on_char ':' line with
  | [ card_str; numbers ] ->
    let winning, have = parse_nums numbers in
    { _id = parse_card card_str; have; winning }
  | _ -> failwith "invalid syntax"
;;

let cards =
  let _lines = Stdin.read_file "inputs/day04.txt" in
  let lines =
    [ "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
    ; "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19"
    ; "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"
    ; "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83"
    ; "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36"
    ; "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    ]
  in
  List.map parse_line lines
;;

let count_matching card =
  let cards =
    List.filter_map
      (fun have -> List.find_opt (fun win -> have == win) card.winning)
      card.have
  in
  List.length cards
;;

(*part1*)
let () =
  let wins = List.map count_matching cards in 
  let () = List.iter print_int wins in
  let () = print_newline () in
  List.map count_matching cards
  |> List.map (Int.shift_left 1)
  |> List.fold_left ( + ) 0
  |> string_of_int
  |> print_endline
;;

(*part2*)
