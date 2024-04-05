type cmplx = R of float * float
           | P of float * float
(*IRect*)           
module type IRect = sig
    val re:  cmplx -> float
    val im:  cmplx -> float
    val add: cmplx -> cmplx -> cmplx
    val sub: cmplx -> cmplx -> cmplx
    val to_str: cmplx -> string                  
end

(*TODO: implement Rect*)
(*Assert error for Polar form cmplx*)
module Rect : IRect = 
  let re = function | R(r, i) -> r | _ -> assert(false)
  let im = function | R(r, i) -> i | _ -> assert(false)
  let add a b = 

(*IPolar*)
module type IPolar = sig
    val mag: cmplx -> float
    val ang: cmplx -> float
    val mul: cmplx -> cmplx -> cmplx
    val div: cmplx -> cmplx -> cmplx
    val to_str: cmplx -> string                  
end

(*TODO: implement Polar*)
(*Assert error for Rect form cmplx*)
module Polar : IPolar = 
  let mag = function | P(m, a) -> m | _ -> assert(false)
  let ang = function | P(m, a) -> a | _ -> assert(false)
  let mul a b = (a, b) |> function 

(*ICmplx*)
module type ICmplx = sig
    (*constructor*)
    val makeR: float -> float -> cmplx
    val makeP: float -> float -> cmplx

    (*accessor*)
    val re:  cmplx -> float
    val im:  cmplx -> float
    val mag: cmplx -> float
    val ang: cmplx -> float

    (*complex arithmetic*)
    val add: cmplx -> cmplx -> cmplx
    val sub: cmplx -> cmplx -> cmplx
    val mul: cmplx -> cmplx -> cmplx
    val div: cmplx -> cmplx -> cmplx

    (*to string*)
    val to_str: cmplx -> string                  
end 

(*TODO: mplement CmplxBuilder functor*)
module CmplxBuilder (Rec:IRect) (Pol:IPolar) : ICmplx = 

module CmplxTestBuilder (C: ICmplx) = struct
    let equ a b = max (a -. b) (b -. a) < 1e-10
    
    let test_add a b = 
        let c = C.add a b in
        assert (equ ((C.re a) +. (C.re b)) (C.re c) &&
                equ ((C.im a) +. (C.im b)) (C.im c))
    let test_sub a b = 
        let c = C.sub a b in
        assert (equ ((C.re a) -. (C.re b)) (C.re c) &&
                equ ((C.im a) -. (C.im b)) (C.im c))
    let test_mul a b = 
        let c = C.mul a b in
        assert (equ ((C.mag a) *. (C.mag b)) (C.mag c) &&
                equ ((C.ang a) +. (C.ang b)) (C.ang c))
    let test_div a b = 
        let c = C.div a b in
        assert (equ ((C.mag a) /. (C.mag b)) (C.mag c) &&
                equ ((C.ang a) -. (C.ang b)) (C.ang c))
    let test () =
        let a = C.makeR 0.1 0.2 in
        let b = C.makeP 0.2 0.3 in
        test_add a b;
        test_sub a b;
        test_mul a b;
        test_div a b
end

module Cmplx  = CmplxBuilder (Rect) (Polar)
module Tester = CmplxTestBuilder (Cmplx)
let _ = Tester.test ()
