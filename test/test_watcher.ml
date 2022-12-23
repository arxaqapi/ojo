open Ojo_lib
open Ojo_lib.Utils

let test_tree () =
  let dir = Watcher.Dir.make ~max_depth:1 "/home/aq" in
  dir.files
  |> Vector.iter (fun e -> Printf.printf "    %s\n" (Watcher.File.get_path e))
(* Watcher.tree "/home/aq" |> Array.iter (Printf.printf "\t%s\n") *)
