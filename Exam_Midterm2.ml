(* CSE216 Programming Abstractions
   Midterm Exam 2 [total 82 pt]
   Date: 5/11/2021, 5:00pm ~ 6:20pm
   Name: Michael Lee
   Student Id: 112424954
*)

(* P1. [12 x 2 pt] What are the terms for the folloiwng explanations?
    Choose your answer from: 
    alpha conversion, applicative order, beta reduction,
    callback, Church-Rosser theorem, continuation, deferred operation, delta reduction,
    eta, reduction, function arguments, iterative process, local variables, normal order,
    modularity, mutable data, referential transparancy, stack frame, state variable,
    streams, substitution model, tail recursive function, Y combinator

    a. A recursive function whose last action is the recursive call: tail recursive function

    b. A signle parameter function that represent the rest of the program: continuation

    c. A process whose state can be summarized by a fixed number of state variables: iterative process

    d. Information about the history of an object to determine the object's current behavior: state variable

    e. A way to model a system with states as a flow of information without using assignments: streams

    f. Equals can be substituted for equals: referential transparency

    g. In event driven simulation, receivers register this to the event generator: callback

    h. In lambda calculus, this operator finds the least fixed point of a function: Y combinator

    i. The simplest form of a lambda expression is unique: Church-Rosser theorem

    j. If any evaluation order of a lambda expression terminates, this evaluation order terminates: normal order

    k. Renaming a variable of a lambda expression: alpha conversion

    l. This operation on a lambda expression corresponds to a function application: beta reduction
*)

(******************************************************************** 
   P2. [5 x 2 pt + 4 x 4 pt] Lambda calculus
********************************************************************)
(*TODO: what are the simpliest forms after reducing the lambda expressions.
        In this problem, \ symbol means lambda
(\ x . x + x) 2 : 4

(\ x . \ y . x) 1 0 : 1

(\ a . \ b . a b a) (\ x . \ y . x) (\ x . \ y . y) 1 0 : 0

(\ c . \ t . \ e . c t e) (\ x . \ y . x) 1 2 : 1

(\ c . \ t . \ e . c t e) (\ x . \ y . y) (\ z . z) (\ z . z + z) 2 : 2

*)

(*TODO: implement succ (successor), add (addition), and 
        mul (multiplication) functions*)
let zero    = fun f x -> x

let succ a  = fun f x -> f (a f x)

let add a b = fun f x -> a f (b f x)

let mul a b = fun f x -> a (b f) x

(* test *)
let to_int n = n (fun x -> x + 1) 0
let one   = succ zero
let two   = add one one
let eight = two |> mul two |> mul two
let _ = zero  |> to_int
let _ = one   |> to_int
let _ = two   |> to_int
let _ = eight |> to_int

(* fixed point *)
type 'a fix = Fix of ('a fix -> 'a)
(* Y combinator *)
let y = fun f -> 
    let k = fun (Fix g) -> fun x -> f (g (Fix g)) x in
    k (Fix k)
(* thunk *)
let force = fun f -> f ()

(* TODO: implement gcd without using let rec.
       - Use Y combinator and force.
       - Do not use church numerals or church booleans*)
let gcd =


(* test *)                    
let _= gcd 15 12


(********************************************************************
   P3. [2 x 4 pt] Continuation Passing Style
********************************************************************)
(* TODO: implement gcd in CPS*)
let rec gcd a b k =
  if a = b then k a
  else if a < b then gcd b a k
  else gcd b a (fun y -> k (y mod b)) in


  



(* test *)
let _ = gcd 15 12 (fun x -> Printf.printf "gcd 15 12: %d\n" x)

(* TODO: implement pi by Nilakantha series in CPS
    - Nilakantha series
       pi = 3 + 4/(2*3*4) - 4/(4*5*6) + 4/(6*7*8) - 4/(8*9*10) + ...
    - add up to n-th terms
*)
let rec pi n k =
    let a = float (2 * n) in
    let sign = (-1.)**(float (n + 1)) in
    let term = sign *. 4. /. (a *. (a +. 1.) *. (a +. 2.)) in


(* test *)        
let _ = pi 100 (fun x -> Printf.printf "pi: %f\n" x)


(********************************************************************
   P4. [2 x 4 pt] Event driven simulation
********************************************************************)
type even_checker = {
    add_action: (int -> unit) -> unit;
    check: int -> unit
}

let make_even_checker name = 
    (* helper functions*)
    let print_name () = 
        Printf.printf "%s\n" name in
    let rec iter f = function
        | [] -> ()
        | h::t -> f h; iter f t in

    let callbacks = ref [] in

    (* TODO: register callback functions to callbacks list
    *)
    let add_action proc = 
    callbacks := proc :: !callbacks; 
    () in



    (* TODO: check function prints its name if n is 0;
       otherwise, it invokes the callbacks with parameter n-1.
       Use the helper functions.
    *)
    let check n =
    if n = 0 then print_name () 
	  else iter (fun x -> x (n - 1)) !callbacks in


    let checker: even_checker = {
        add_action = add_action;
        check = check
    } in
    checker

let is_even n =
    let a = make_even_checker "even"  in
    let b = make_even_checker "odd"   in
    a.add_action b.check;
    b.add_action a.check;
    a.check n

(* test *)
let _ = is_even 7
let _ = is_even 8

(********************************************************************
   P5. [4 x 4 pt]streams
********************************************************************)
type 'a stream = Nil | Cons of 'a * (unit -> 'a stream)

let car s = 
    match s with 
    | Nil -> assert false
    | Cons (x, _) -> x 

let cdr s =     
    match s with 
    | Nil -> assert false
    | Cons (_, f) -> f () 
    
let rec constant c = Cons (c, fun () -> constant c)
let rec ones  = constant 1. 

(* TODO: implement scale. It scales a float stream by s
   e.g. scale 2 [1, 2, 3, 4, ...] = [2, 4, 6, 8,, ...]
*)
let rec from x = Cons (x, fun () -> from (x +. 1.))
let nat = from 1.
let rec scale s strm = if strm = Nil then Nil else Cons (s *. (car strm), fun() -> scale s (cdr strm))



(* TODO: implement add. It adds two float streams
   e.g. add [1, 2, 3, 4, ...] [1, 1, 1, 1, ...] = [2, 3, 4, 5,, ...]
*)
let rec add a_strm b_strm = if a_strm = Nil then b_strm else if b_strm = Nil then a_strm else Cons ((car a_strm) +. (car b_strm), fun() -> add (cdr a_strm) (cdr b_strm))



(* TODO: implement accumulate. It returns the float stream of
   the accumulated sum of the elements.
   e.g. accumulate [1, 2, 3, 4, ...] = [1, 3, 6, 10, ...]
*)
let accumulate strm =
    let rec iter acc strm =
      if strm = Nil then Nil
      else Cons((car strm) +. acc, fun() -> iter (acc +. car strm) (cdr strm)) in 

    iter 0. strm

(* TODO: implement difference. It returns the float stream of
   the difference from the previous element to the next element.
   The previous element of the first element is 0.
   e.g. difference [1, -2, 3, -4, ...] = [1, -3, 5, -7, ...]
*)
let difference strm =
    let rec iter prev strm =
      if strm = Nil then Nil
      else Cons((car strm) -. prev, fun() -> iter (car strm) (cdr strm)) in
    iter 0. strm


(* test *)
let rec print strm n =
    if n > 0 then  begin
        Printf.printf "%f, " (car strm);
        print (cdr strm) (n - 1)
    end
    else
        Printf.printf "\n"

let a = scale 2. ones
let _ = print a 5

let b = add a (scale (-1.) ones)
let _ = print b 5

let c = accumulate b
let _ = print c 5

let d = difference c
let _ = print d 5