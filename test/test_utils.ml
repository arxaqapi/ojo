open Ojo_lib

let info (v : int Utils.Vector.t) =
  Printf.printf "> capacity: %d\n" v.capacity;
  Printf.printf "> size: %d\n" v.size;
  Printf.printf "> ";
  Array.iter (Printf.printf "%d ") v.mem;
  print_newline ()

let test_vec () =
  let v = Utils.Vector.make_empty () in
  for i = 1 to 10 do
    Utils.Vector.push v (int_of_float (2. ** float_of_int i))
  done;
  info v
