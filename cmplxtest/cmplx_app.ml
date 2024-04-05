open Cmplx
(*a program using complex arithmetic package*)
let to_rect c = Cmplx.rect (Cmplx.re c) (Cmplx.im c)
let to_polar c = polar (mag c) (ang c)
let a = rect 3. 4.
let b = rect 1. 2.
let c = div a b
let _ = Printf.printf "%s\n" (to_str (to_rect c))
let _ = Printf.printf "%s\n" (to_str (to_polar c))
let _ = exit 0 (*to terminate the process*)