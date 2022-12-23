module Array = struct
  include Array

  let findi_opt p a =
    let n = length a in
    let rec loop i =
      if i = n then None
      else
        let x = unsafe_get a i in
        if p x then Some i else loop (succ i)
    in
    loop 0
end

module Vector = struct
  type 'a t = {
    (* Internal  *)
    mutable mem : 'a array;
    (* Current size of the  *)
    mutable size : int;
    (* Total capacity of the vector before resizing *)
    mutable capacity : int;
  }

  let push v e =
    match v.size with
    | 0 ->
        v.mem <- Array.make 1 e;
        v.size <- 1;
        v.capacity <- 1
    (* capacity is doubled *)
    | c when c = v.capacity ->
        (* double size of the array *)
        let old = v.mem in
        v.mem <- Array.make (v.capacity * 2) e;
        (* copy old elements into array *)
        Array.iteri (fun i e -> v.mem.(i) <- e) old;
        (* add e to end of array *)
        v.mem.(v.size) <- e;
        (* update v.size -> succ v.size and v.capacity -> v.capacity * 2  *)
        v.size <- succ v.size;
        v.capacity <- v.capacity * 2
    (* add at the end *)
    | _ ->
        v.mem.(v.size) <- e;
        v.size <- succ v.size

  let make_empty () : 'a t = { mem = [||]; size = 0; capacity = 0 }
  let empty v = v.size = 0
  let get v i = v.mem.(i)

  (* let map *)
  let find_opt p v =
    (* only for the size and not the capacity *)
    let n = v.size in
    let rec loop i =
      if i = n then None
      else
        let x = get v i in
        if p x then Some x else loop (succ i)
    in
    loop 0

  let iter f v =
    for i = 0 to v.size - 1 do
      f (get v i)
    done
end
