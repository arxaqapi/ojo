open Utils

exception Unix_stat_error
exception Cannot_retrieve_unix_stats

let get_modification_time filename =
  try Ok (int_of_float (Unix.stat filename).st_mtime)
  with Unix.Unix_error _ -> Error Unix_stat_error

module FileData = struct
  type t = { mutable last_modification_time : int }

  let make_exn path =
    {
      last_modification_time =
        (match get_modification_time path with
        | Ok i -> i
        | Error _ -> raise Cannot_retrieve_unix_stats);
    }

  (** Update FileData modification time with argument value or get last system value *)
  let update_modification_time_exn ?time f path =
    f.last_modification_time <-
      (match time with
      | Some t -> t
      | None -> (
          match get_modification_time path with
          | Ok i -> i
          | Error _ -> raise Cannot_retrieve_unix_stats))

  (** Returns true if the file has been modified. The internal last modification time is also updated.*)
  let has_been_modified_exn f path =
    match get_modification_time path with
    | Ok time ->
        let res = time - f.last_modification_time > 0 in
        update_modification_time_exn ~time f path;
        res
    | Error _ -> raise Cannot_retrieve_unix_stats
end

module Dir = struct
  type t = {
    path : string;
    (* path -> FileData.t *)
    files : (string, FileData.t) Hashtbl.t;
  }

  (** Creates a Dir structure and populates its internal files corresponding to the [path] parameter *)
  let make ?(max_depth = 3) path =
    let files = Hashtbl.create 10 in
    let rec explore_tree depth cur_path =
      if depth >= 0 then
        match (Unix.lstat cur_path).st_kind with
        | Unix.S_DIR ->
            (* If dir, recursively explore files in dir *)
            Array.iter
              (fun sub_path ->
                explore_tree (pred depth)
                  (cur_path ^ Filename.dir_sep ^ sub_path))
              (Sys.readdir cur_path)
        | Unix.S_REG -> (
            try Hashtbl.add files cur_path (FileData.make_exn cur_path)
            with Cannot_retrieve_unix_stats -> ())
        | _ -> () (* Do nothing *)
    in
    explore_tree max_depth path;
    { path; files }

  (** Loop over all files in the specified directory and return true if a modification has been detected *)
  let files_have_been_modified d =
    let to_remove_q = Queue.create () in
    let res =
      Hashtbl.fold
        (fun k_path f_data b ->
          (* Handle Cannot_retrieve_unix_stats errors *)
          try FileData.has_been_modified_exn f_data k_path || b
          with Cannot_retrieve_unix_stats ->
            Queue.push k_path to_remove_q;
            true || b)
        d.files false
    in
    (* Remove faulty elements in queue from table *)
    Queue.iter (fun p -> Hashtbl.remove d.files p) to_remove_q;
    res
end

(** Watch for modifications in a specific path (file or directory) *)
let watch_path path delay max_depth f =
  (match Sys.is_directory path with
  | true ->
      Rainbow.print Yellow @@ "Watching for modification in directory (depth="
      ^ string_of_int max_depth ^ "): " ^ path
  | false ->
      Rainbow.print Yellow @@ "Watching for modification in file: " ^ path);

  let d = Dir.make ~max_depth path in
  let rec watch_process () =
    Unix.sleepf delay;
    (* execute function f if modifications are detected *)
    if Dir.files_have_been_modified d then f ();
    watch_process ()
  in
  watch_process ()
