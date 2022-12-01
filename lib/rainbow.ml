type colors = Gray | Red | Green | Yellow | Blue | Purple | Cyan

let color_to_code = function
  | Gray -> "90"
  | Red -> "91"
  | Green -> "92"
  | Yellow -> "93"
  | Blue -> "94"
  | Purple -> "95"
  | Cyan -> "96"

let prefix color_indicator = "\027[" ^ color_indicator ^ "m"
let suffix = prefix ""
let print color s = prefix (color_to_code color) ^ s ^ suffix |> print_endline
