(* Newton's method
 *)

let newton f x0 =
    let eps = 1e-10 in

    (*absolute value of x*)
    let abs x =
    if x < 0. then -1. *. x else x in

    (*find the derivative of f: (f(x + eps) - f(x)) / eps*)
    let derivative f = fun x -> (f(x +. eps) -. f(x)) /. eps in

    (*f'(x)*) 
    let dfdx = derivative f in

    (*find the next guess from the current guess*)
    let next f = fun x -> x -. f(x) /. (dfdx(x)) in

    (*fixed point of f is x such that x = f(x) *)
    let rec fixed_point f x =
    if abs (f(x) -. x) < eps then x
    else fixed_point f (f(x)) in
        
    fixed_point (next f) x0 


(*sqrt of x using newton*)    
let sqrt x = newton(fun y -> y *. y -. x) 10.

let _ = sqrt 2.