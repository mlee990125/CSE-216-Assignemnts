module type X_int = sig 
  val x: int
end

module Increment (M: X_int): X_int = struct
  let x = M.x + 1
end

module One : X_int = struct
  let x = 1
end

module Two = Increment(One)
module Three = Increment(Two)

let _ = Printf.printf "%d\n" One.x
let _ = Printf.printf "%d\n" Two.x
let _ = Printf.printf "%d\n" Three.x

