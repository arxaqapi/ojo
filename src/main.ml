open Ojo_lib

let () =
  let delay, command, max_depth, path_to_watch =
    Arg_parser.parse_arguments ()
  in
  Watcher.watch_path path_to_watch delay max_depth (fun () ->
      Rainbow.print Blue "👁  Modifications detected";
      let command_status, command_output = Shexec.shexec command in
      List.iter
        (fun s ->
          Rainbow.print
            (match command_status with WEXITED 0 -> Gray | _ -> Red)
            ("  | " ^ s))
        command_output)
