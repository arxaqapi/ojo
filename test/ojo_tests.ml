open Ojo_lib

let () =
  Test_rainbow.print_all_colors ();
  Test_utils.test_vec ();

  Rainbow.print Green "\n[Test] - All tests passed"
