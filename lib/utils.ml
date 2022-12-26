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
