open Aoc_2023

type part =
  { num : int
  ; spos : int * int
  ; symb : char
  }

let is_digit c =
  match c with
  | '0' .. '9' -> true
  | _ -> false
;;

let is_symb c = (not (is_digit c)) && c != '.'

let schematic =
  let lines = Stdin.read_file "inputs/day03.txt" in
  Array.of_list @@ List.map (fun line -> String.to_seq line |> Array.of_seq) lines
;;

module IntPairs = struct
  type t = int * int

  let compare (x0, y0) (x1, y1) =
    match Stdlib.compare x0 x1 with
    | 0 -> Stdlib.compare y0 y1
    | c -> c
  ;;
end

module PairsSet = Set.Make (IntPairs)

let symb_pos = ref PairsSet.empty

let () =
  Array.iteri
    (fun i row ->
      Array.iteri
        (fun j c -> if is_symb c then symb_pos := PairsSet.add (i, j) !symb_pos)
        row)
    schematic
;;

let seen = ref PairsSet.empty
let dirs = [ -1, -1; -1, 0; -1, 1; 1, -1; 1, 0; 1, 1; 0, -1; 0, 1 ]
let symbols_pos = PairsSet.to_list !symb_pos

let in_bounds (x, y) =
  x >= 0 && x < Array.length schematic && 0 <= y && y < Array.length schematic.(0)
;;

let find_num (x, y) =
  if not (is_digit schematic.(x).(y))
  then None
  else (
    let rec find_start y =
      if in_bounds (x, y - 1) && is_digit schematic.(x).(y - 1)
      then find_start (y - 1)
      else y
    in
    let rec find_end y =
      if in_bounds (x, y + 1) && is_digit schematic.(x).(y + 1)
      then find_end (y + 1)
      else y
    in
    let start = find_start y in
    let stop = find_end y in
    let len = stop - start + 1 in
    let () =
      let range = List.init len (fun i -> start + i) in
      List.iter (fun y -> seen := PairsSet.add (x, y) !seen) range
    in
    Some
      (Array.sub schematic.(x) start len |> Array.to_seq |> String.of_seq |> int_of_string))
;;

let parts =
  List.map
    (fun (x, y) ->
      List.filter_map
        (fun (dx, dy) ->
          let pos = x + dx, y + dy in
          if in_bounds pos && PairsSet.find_opt pos !seen |> Option.is_none
          then (
            let num = find_num pos in
            match num with
            | Some n -> Some { spos = (x, y); num = n; symb = schematic.(x).(y) }
            | None -> None)
          else None)
        dirs)
    symbols_pos
  |> List.flatten
;;

(*part1*)
let () =
  List.fold_left (fun acc part -> acc + part.num) 0 parts
  |> string_of_int
  |> print_endline
;;

(*part2*)

module PartsMap = Map.Make (IntPairs)

let _ =
  let () = print_endline "part 2" in
  let mapping =
    List.filter (fun part -> part.symb == '*') parts
    |> List.fold_left
         (fun map part -> PartsMap.add_to_list part.spos part map)
         PartsMap.empty
  in
  let mapping = PartsMap.filter (fun _ v -> List.length v == 2) mapping in
  PartsMap.fold
    (fun _ v acc -> acc + List.fold_left (fun acc part -> acc * part.num) 1 v)
    mapping
    0
  |> string_of_int
  |> print_endline
;;
