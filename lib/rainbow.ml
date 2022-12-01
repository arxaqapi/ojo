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

(* For fprintf, you can use ^^:
   let fprintf ppf fmt = if glob then Format.fprintf ppf ("("^^fmt ^^ ")") else Format.fprintf ppf fmt *)

(* ======================== *)
(* type bg_colors = B_Gray | B_Red | B_Green | B_Yellow | B_Blue | B_Purple | B_Cyan | B_white *)

(* let bg_color_to_code = function
   | B_Gray   -> "40"
   | B_Red    -> "41"
   | B_Green  -> "42"
   | B_Yellow -> "43"
   | B_Blue   -> "44"
   | B_Purple -> "45"
   | B_Cyan   -> "46"
   | B_white -> "47" *)
