(*https://en.wikipedia.org/wiki/Church_encoding*)
(*http://www.cs.cornell.edu/courses/cs6110/2014sp/Handouts/church.ml*)
(*https://www.cs.umd.edu/class/fall2017/cmsc330/lectures/02-lambda-calc-encodings.pdf*)

type church = B of (church -> church -> church)                 (*boolean*)
            | N of ((church -> church) -> church -> church)     (*number*)
            | P of (church -> church)                           (*pair*)
            | T of (church -> church)                           (*thunk*)
            | I of int                                          (*to display*)

type 'a fix = Fix of ('a fix -> 'a)                             (*fixed point*)


(**************************************************************
** Helper functions
**************************************************************)

let curry2 f = fun a -> fun b -> f (a, b)
let curry3 f = fun a -> fun b -> fun c -> f (a, b, c)
(*convert Church numeral and Church boolean to int*)    
let to_int a =
    let inc = function I i -> I (i + 1) | _ -> assert false in
    let ret = function I i -> i         | _ -> assert false in
    match a with
    | (N n) -> n inc (I 0)   |> ret
    | (B p) -> p (I 1) (I 0) |> ret
    | _ -> assert false


(**************************************************************
** Church boolean
**************************************************************)

(*TODO: implement true and false*)
let true'  = B (fun x -> fun y -> x)
let false' = B (fun x -> fun y -> y)

(*logical operators*)
(*TODO: implement and, or, not, and if*)
let and' = curry2 (function | (B (x), B (y)) -> x (B y) (B x) | _ -> assert false)
let or'  = curry2 (function | (B x, B y) -> x (B x) (B y) | _ -> assert false)
let not' = function | (B b) -> b false' true' | _ -> assert false
let if'  = curry3 (function | (B c, B t, B e) -> c (B t) (B e) | _ -> assert false)

(*test boolean*)
let _ = Printf.printf("--testing boolean---------\n")
let _ = assert (to_int true' = 1)
let _ = assert (to_int false' = 0)
let _ = assert (to_int (and' false' false') = 0)
let _ = assert (to_int (and' false' true' ) = 0)
let _ = assert (to_int (and' true'  false') = 0)
let _ = assert (to_int (and' true'  true')  = 1)

let _ = assert (to_int (or'  false' false') = 0)
let _ = assert (to_int (or'  false' true' ) = 1)
let _ = assert (to_int (or'  true'  false') = 1)
let _ = assert (to_int (or'  true'  true')  = 1)

let _ = assert (to_int (not' false') = 1)
let _ = assert (to_int (not' true' ) = 0)

let _ = assert (to_int (if'  true'  true'  false')  = 1)
let _ = assert (to_int (if'  false' true'  false')  = 0)
let _ = Printf.printf("--testing boolean done----\n")


(**************************************************************
** Church pair
**************************************************************)

(*TODO: implement cons, car and cdr*)
let cons = curry2 (function | (B x, B y) -> P(fun (B f) -> f (B x) (B y)) | (B x, P y) -> P(fun (B f) -> f (B x) (P y)) | (_, _) -> assert false )
let car  = function | (P c) -> c true' | _ -> assert false
let cdr  = function | (P c) -> c false' | _ -> assert false

(*TODO: implement nil and is_nil*)
let nil    = B (fun x -> fun y -> true')
let is_nil = function | (B x) -> true' | _ -> false'

(*test pair*)
let _ = Printf.printf("--testing pair------------\n")
let _ = assert (to_int (car (cons true' false')) = 1)
let _ = assert (to_int (cdr (cons true' false')) = 0)
let _ = assert (to_int      (car (cons false' (cons true' false')))  = 0)
let _ = assert (to_int (car (cdr (cons false' (cons true' false')))) = 1)
let _ = assert (to_int (cdr (cdr (cons false' (cons true' false')))) = 0)

let _ = assert (to_int (is_nil nil)                 = 1)
let _ = assert (to_int (is_nil (cons true' false')) = 0)
let _ = Printf.printf("--testing pair done-------\n")

(**************************************************************
** Church numeral
**************************************************************)


(*TODO: implement zero and succ*)
let zero = N (fun f -> fun x -> x)
let succ = function | (N n) -> N (fun f x -> f (n f x)) | _ -> assert false

(*arithmetic operators*)
(*TODO: implement add and mul*)
let add = curry2 (function | (N m, N n) -> N (fun f x -> m f (n f x)) | _ -> assert false)
let mul = curry2 (function | (N m, N n) -> N (fun f x -> m (n f) x)| _ -> assert false)

(*pred and sub*)
let pred = function N n ->
    let next = fun p -> cons (cdr p) (succ (cdr p)) in
    car (n next (cons zero zero)) | _ -> assert false
let sub = curry2 (function (N m, N n) -> (n pred) (N m) | _ -> assert false) (*m - n*)

(*comparators*)
(*TODO: implement is_zero*)
let is_zero = function | (N n) -> (n (fun x -> false') true') | _ -> assert false

let leq     = fun m -> fun n -> is_zero (sub m n)
let equ     = fun m -> fun n -> and' (leq m n) (leq n m)

(*test number*)
let _ = Printf.printf("--testing number----------\n")
let one   = succ zero
let two   = add one   one
let four  = add two   two
let eight = add four  four
let three = add two   one
let five  = add four  one
let six   = add four  two
let seven = add four  three
let nine  = add eight one


let _ = assert (to_int zero  = 0)
let _ = assert (to_int one   = 1)
let _ = assert (to_int two   = 2)
let _ = assert (to_int three = 3)
let _ = assert (to_int four  = 4)
let _ = assert (to_int five  = 5)
let _ = assert (to_int six   = 6)
let _ = assert (to_int seven = 7)
let _ = assert (to_int eight = 8)
let _ = assert (to_int nine  = 9)

let _ = assert (to_int (mul zero two)   = 0)
let _ = assert (to_int (mul one  two)   = 2)
let _ = assert (to_int (mul two  three) = 6)
let _ = Printf.printf("hi")
let _ = assert (to_int (is_zero zero)   = 1)
let _ = assert (to_int (is_zero one)    = 0)
let _ = assert (to_int (is_zero two)    = 0)

let _ = assert (to_int (leq zero two)   = 1)
let _ = assert (to_int (leq one  two)   = 1)
let _ = assert (to_int (leq two zero)   = 0)
let _ = assert (to_int (leq two one)    = 0)

let _ = assert (to_int (equ zero zero)  = 1)
let _ = assert (to_int (equ one  two)   = 0)
let _ = assert (to_int (equ two  one)   = 0)
let _ = assert (to_int (equ two  two)   = 1)
let _ = Printf.printf("--testing number done-----\n")


(**************************************************************
** Y combinator
**************************************************************)

(* the usual def of Y combinator as below does not work
    in the applicative order eval
    let y = fun f -> 
        let k = fun (Fix g) -> f (g (Fix g)) in
        k (Fix k)
*) 
let y = fun f -> 
    let k = fun (Fix g) -> fun x -> f (g (Fix g)) x in
    k (Fix k)
    
(*thunk*)
let force = function T f -> f false' | _ -> assert false

(*factorial*)    
let fact = 
    y (fun self x ->
        force (if' (is_zero x)
                   (T (fun _ -> succ zero))
                   (T (fun _ -> mul x (self (pred x))))))
    
(*gcd*)
(*TODO: implement gcd*)    
let gcd =
let gcd' g a b = 
		force  (if' (equ a b) 
					(T (fun a
					(if' (leq b a)
						(gcd' (sub (N b) (N a)) b)
						(gcd' (sub (N a) (N b)) a))) in
	y gcd'

(*map*)
(*TODO: implement map*)    
let map =


(*test Y combinator*)
let _ = Printf.printf("--testing Y---------------\n")
let _ = assert (to_int (fact four)    = 24)
let _ = assert (to_int (gcd six nine) = 3)
let lst = map (fun x -> add x x) (cons one (cons two (cons three nil)))
let _ = assert (to_int (car lst)             = 2)
let _ = assert (to_int (car (cdr lst))       = 4)
let _ = assert (to_int (car (cdr (cdr lst))) = 6)
let _ = Printf.printf("--testing Y done----------\n")
