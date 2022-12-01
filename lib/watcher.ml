exception Not_Supported

let get_modification_time filename = int_of_float (Unix.stat filename).st_mtime

let watch_file file delay f =
  Rainbow.print Yellow @@ "Watching for modification in file: " ^ file;
  let rec watch_process base_modification_time =
    Unix.sleepf delay;
    let last_mod_time = get_modification_time file in
    match last_mod_time - base_modification_time > 0 with
    | false -> watch_process last_mod_time (* no modification detected *)
    | true ->
        (* execute function f if modifications detected *)
        f ();
        watch_process last_mod_time
  in
  match (Unix.stat file).st_kind with
  | S_REG -> watch_process (get_modification_time file) (* Ok *)
  | _ -> raise Not_Supported
