open Ojo_lib

let () =
  Test_rainbow.print_all_colors ();
  Test_watcher.test_tree ();

  Rainbow.print Green "\n[Test] - All tests passed"
