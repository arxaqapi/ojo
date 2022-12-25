open Ojo_lib

let test_tree () =
  let _dir = Watcher.Dir.make ~max_depth:1 "/home/aq" in
  Hashtbl.iter (fun k _v -> Printf.printf "\t%s\n" k) _dir.files
