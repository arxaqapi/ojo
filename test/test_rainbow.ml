open Ojo_lib

let colors : Rainbow.colors list =
  [ Gray; Red; Green; Yellow; Blue; Purple; Cyan ]

let print_all_colors () =
  List.iter (fun color -> Rainbow.print color "Test color sentence") colors
