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
    { red = 0; green = 0; blue = 0 }
    pairs
;;

let parse_draws line =
  let draw_strs = String.split_on_char ';' line in
  List.map parse_draw draw_strs
;;

let parse line =
  let slist = String.split_on_char ':' line in
  match slist with
  | [ game_str; records ] ->
    let game_id = List.nth (String.split_on_char ' ' game_str) 1 |> int_of_string in
    let draws = String.trim records |> parse_draws in
    { id = game_id; draws }
  | _ -> failwith "invalid format"
;;

let games =
  let lines = Stdin.read_file "inputs/day02.txt" in
  List.map parse lines
;;

let all f xs =
  let fs = List.filter f xs in
  List.compare_lengths fs xs == 0
;;

(*part1*)
let () =
  let check_game game =
    all (fun draw -> draw.red <= 12 && draw.green <= 13 && draw.blue <= 14) game.draws
  in
  let possible =
    List.filter_map (fun game -> if check_game game then Some game.id else None) games
  in
  List.fold_left (+) 0 possible |> string_of_int |> print_endline
;;

let power game = game.red * game.green * game.blue

(*part2*)
let () =
  let min_game game =
    List.fold_left
      (fun acc x ->
        { red = max acc.red x.red
        ; green = max acc.green x.green
        ; blue = max acc.blue x.blue
        })
      { red = 0; green = 0; blue = 0 }
      game.draws
  in
  List.fold_left (fun acc x -> acc + (min_game x |> power)) 0 games
  |> string_of_int
  |> print_endline
;;
