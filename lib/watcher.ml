open Utils

let get_modification_time filename = int_of_float (Unix.stat filename).st_mtime

module File = struct
  type t = { path : string; mutable last_modification_time : int }

  let get_path f = f.path
  let make path = { path; last_modification_time = get_modification_time path }

  let update_modification_time f =
    f.last_modification_time <- get_modification_time f.path

  (** Returns true if the file has been modified. The internal last modification time is also updated.*)
  let has_been_modified f =
    let b = get_modification_time f.path - f.last_modification_time > 0 in
    update_modification_time f;
    b
end

module Dir = struct
  type t = { path : string; files : File.t Vector.t }

  (* NOTE: make function cleaner and better? *)

  (** Creates a Dir structure and populates its internal list corresponding to the [path] parameter *)
  let make ?(max_depth = 3) path =
    let files = Vector.make_empty () in
    (* If we have a directory, recursively add all files to the Dir.files record field *)
    (* NOTE: remove duplicate code *)
    if Sys.is_directory path then
      let rec explore_tree depth cur_path =
        if depth > 0 then
          Array.iter
            (fun current_f ->
              let new_path = cur_path ^ Filename.dir_sep ^ current_f in
              match (Unix.lstat new_path).st_kind with
              | Unix.S_DIR ->
                  explore_tree (pred depth) new_path (* handles a subdir*)
              | Unix.S_REG -> Vector.push files (File.make new_path)
              | _ -> () (* Do nothing *))
            (Sys.readdir cur_path)
      in
      explore_tree max_depth path
    else Vector.push files (File.make path);
    { path; files }

  (** Loop over all files in the specified directory and return true if a modification has been detected *)
  let files_have_been_modified d =
    (*FIXME - If a file is deleted during the watch time, the program cannot retrieve its stats
      > handle error and do nothing
      > OR use another data structure and remove deleted entries
    *)
    match Vector.find_opt (fun f -> File.has_been_modified f) d.files with
    | Some _ -> true
    | _ -> false
end

(** Watch for modifications in a specific path (file or directory) *)
let watch_path path delay f =
  (* NOTE: remove duplicate code *)
  (match Sys.is_directory path with
  | true ->
      Rainbow.print Yellow @@ "Watching for modification in directory: " ^ path
  | false ->
      Rainbow.print Yellow @@ "Watching for modification in file: " ^ path);
  let d = Dir.make path in
  let rec watch_process () =
    Unix.sleepf delay;
    if Dir.files_have_been_modified d then (
      (* execute function f if modifications detected *)
      f ();
      watch_process ())
    else watch_process () (* no modification detected *)
  in
  watch_process ()
