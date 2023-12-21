open Aoc_2023

type draw =
  { green : int
  ; red : int
  ; blue : int
  }

type game =
  { id : int
  ; draws : draw list
  }

let parse_draw str =
  let draw_str = String.split_on_char ',' str in
  let pairs =
    List.map
      (fun s ->
        let color_count = String.trim s |> String.split_on_char ' ' in
        match color_count with
        | [ i; "green" ] -> { green = int_of_string i; red = 0; blue = 0 }
        | [ i; "red" ] -> { red = int_of_string i; green = 0; blue = 0 }
        | [ i; "blue" ] -> { blue = int_of_string i; red = 0; green = 0 }
        | _ -> failwith "unknown color")
      draw_str
  in
  List.fold_left
    (fun acc d ->
      { green = acc.green + d.green; red = acc.red + d.red; blue = acc.blue + d.blue })
    { red = 0; green = 0; blue = 0 } pairs
;;

let parse_draws line =
  let draw_strs = String.split_on_char ';' line in
  List.map parse_draw draw_strs
;;

let parse line =
  let slist = String.split_on_char ':' line in
  match slist with
  | [game_str ;records] ->
    let game_id = List.nth (String.split_on_char ' ' game_str) 1 |> int_of_string in
    let draws = String.trim records |> parse_draws in
    { id = game_id; draws = draws}
  | _ -> failwith "invalid format"
;;

let games = 
let lines = Stdin.read_file "inputs/day02.txt" in
List.map parse lines

let () = List.filter_map
