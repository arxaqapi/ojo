open Ojo_lib

let () =
  let delay, command, file_to_watch = Arg_parser.parse_arguments () in
  Watcher.watch_file file_to_watch delay (fun () ->
      Rainbow.print Blue "👁  Modifications detected";
      match Shexec.shexec command with
      | WEXITED 0, command_output ->
          List.iter (fun s -> Rainbow.print Gray @@ "  | " ^ s) command_output
      (* Error detected: exit > 0 or killed by signal or stopped by signal *)
      | _, command_output ->
          List.iter (fun s -> Rainbow.print Red @@ "  | " ^ s) command_output)
