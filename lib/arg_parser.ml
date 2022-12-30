let usage_message =
  "ojo <file|directory> [-d delay_in_seconds] [--depth max_depth] -x \
   <\"command to execute\">"

let delay = ref 2.0
let max_depth = ref 3
let command = ref ""
let files_to_watch = Queue.create ()
let handle_anon_args file = Queue.push file files_to_watch

let ojo_speclist =
  (* TODO - Fix argument names *)
  [
    ( "-d",
      Arg.Set_float delay,
      "Minimum delay, in seconds, between two execution" );
    ("--depth", Arg.Set_int max_depth, "Maximum search depth for files to watch");
    ("-x", Arg.Set_string command, "The command to execute on change");
  ]

let parse_arguments () =
  Arg.parse ojo_speclist handle_anon_args usage_message;

  if !command = "" then (
    Rainbow.print Yellow "Command to execute. If empty, nothing will happen.";
    Arg.usage ojo_speclist usage_message;
    exit 1);
  match Queue.length files_to_watch with
  | 0 ->
      Rainbow.print Red
        "No file or directory has been given as input, please provide one.";
      Arg.usage ojo_speclist usage_message;
      exit 1
  | _ -> (!delay, !command, !max_depth, Queue.peek files_to_watch)
(* Returns only the first path to watch *)
