let read_file path =
  let content =
    match path with
    | "-" -> In_channel.input_all In_channel.stdin
    | path -> In_channel.open_text path |> In_channel.input_all
  in
  String.split_on_char '\n' content
