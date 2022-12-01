let shexec command =
  (* Carefull: There are no guards for infinitely long commands *)
  let rec read_all channel =
    match In_channel.input_line channel with
    | None -> (Unix.close_process_in channel, [] (* end of channel reached *))
    | Some s ->
        let status, commands = read_all channel in
        (status, s :: commands)
  in
  Unix.open_process_in command |> read_all
