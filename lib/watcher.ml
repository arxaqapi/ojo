open Utils

exception UnixStatError
exception FileDataError

let get_modification_time filename =
  try Ok (int_of_float (Unix.stat filename).st_mtime)
  with Unix.Unix_error _ -> Error UnixStatError

module FileData = struct
  type t = { mutable last_modification_time : int }

  let make_exn path =
    {
      last_modification_time =
        (match get_modification_time path with
        | Ok i -> i
        | Error _ -> raise FileDataError);
    }

  let update_modification_time_exn f path =
    f.last_modification_time <-
      (match get_modification_time path with
      | Ok i -> i
      | Error _ -> raise FileDataError)

  (** Returns true if the file has been modified. The internal last modification time is also updated.*)
  let has_been_modified_exn f path =
    match get_modification_time path with
    | Ok time ->
        let res = time - f.last_modification_time > 0 in
        (* TODO - handle error *)
        update_modification_time_exn f path;
        res
    | Error _ -> raise FileDataError
end

module Dir = struct
  (* TODO - Error should be handled better (with Options or Results) *)
  type t = {
    path : string;
    (* path -> FileData.t *)
    files : (string, FileData.t) Hashtbl.t;
  }

  (** Creates a Dir structure and populates its internal files corresponding to the [path] parameter *)
  let make ?(max_depth = 3) path =
    let files = Hashtbl.create 10 in
    (* If we have a directory, recursively add all files to the Dir.files record field *)
    (* NOTE: remove duplicate code *)
    if Sys.is_directory path then
      (* Recursively explore the file tree structure on disk *)
      let rec explore_tree depth cur_path =
        if depth > 0 then
          Array.iter
            (fun current_f ->
              let new_path = cur_path ^ Filename.dir_sep ^ current_f in
              match (Unix.lstat new_path).st_kind with
              | Unix.S_DIR ->
                  explore_tree (pred depth) new_path (* handles a subdir*)
              | Unix.S_REG ->
                  (* TODO - Handle error / better handling
                     If fail, do not add *)
                  Hashtbl.add files new_path (FileData.make_exn new_path)
              | _ -> () (* Do nothing *))
            (Sys.readdir cur_path)
      in
      explore_tree max_depth path (* TODO - If fail, do not add *)
    else Hashtbl.add files path (FileData.make_exn path);
    { path; files }

  (** Loop over all files in the specified directory and return true if a modification has been detected *)
  let files_have_been_modified d =
    let to_remove_q = Queue.create () in
    let res =
      Hashtbl.fold
        (fun k_path f_data b ->
          (* Handle FileDataError errors *)
          try FileData.has_been_modified_exn f_data k_path || b
          with FileDataError ->
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
  (* NOTE: remove duplicate code *)
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
