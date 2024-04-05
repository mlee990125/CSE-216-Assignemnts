(*last change 4/27/2020 11:15am*)
(*https://en.wikipedia.org/wiki/Church_encoding*)

module type CHURCH = sig
    type church = B of (church -> church -> church)                 (*boolean*)
                | N of ((church -> church) -> church -> church)     (*number*)
                | P of (church -> church)                           (*pair*)
                | T of (church -> church)                           (*thunk*)
                | I of int                                          (*to test*)
    type 'a fix = Fix of ('a fix -> 'a)
    
    (*Church Boolean*)
    val true' : church
    val false': church
   
    val if'   : church -> church -> church -> church
    val and'  : church -> church -> church
    val or'   : church -> church -> church
    val not'  : church -> church

    (*Church pair*)
    val cons  : church -> church -> church
    val car   : church -> church
    val cdr   : church -> church

    (*Church numeral*)
    val zero  : church
    val succ  : church -> church
    val pred  : church -> church
    val add   : church -> church -> church
    val mul   : church -> church -> church
    val sub   : church -> church -> church
    val is_zero : church -> church
    val leq   : church -> church -> church
    val equ   : church -> church -> church

    (*Y combinator*)
    val y : (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b

    (*helper*)
    val force  : church -> church
    val to_int : church -> int
end

module Church : CHURCH = struct
    type church = B of (church -> church -> church)                 (*boolean*)
                | N of ((church -> church) -> church -> church)     (*number*)
                | P of (church -> church)                           (*pair*)
                | T of (church -> church)                           (*thunk*)
                | I of int                                          (*to test*)
    type 'a fix = Fix of ('a fix -> 'a)

    (*
      helper functions
    *)
    let curry2 f = fun a -> fun b -> f (a, b)
    let curry3 f = fun a -> fun b -> fun c -> f (a, b, c)

    (*
      Church booleans
    *)
    let true'  = B (fun a b -> a)
    let false' = B (fun a b -> b)

    (*logical operators*)
    let if'  = curry3 (function (B c, t, f) -> c t f | _ -> assert false)
    let and' = curry2 (function (B a, B b) -> a (B b)(B a) | _ -> assert false)
    let or'  = curry2 (function (B a, B b) -> a (B a) (B b) | _ -> assert false)
    let not' = function (B b) -> b false' true' | _ -> assert false

    (*
      Church pair
    *)
    let cons = curry2 (function (N a, N b) -> P(fun (B f) -> f(N a) (N b)) | _ -> assert false)
    let car  = function (P c) -> c true' | _ -> assert false
    let cdr  = function (P c) -> c false' | _ -> assert false

    (*
      Church numerals
    *)
    let zero = N (fun f x -> x)
    let succ = function (N n) -> N (fun f x -> f (n f x)) | _ -> assert false;;
    let pred = function (N n) -> (car(n (fun p -> cons (cdr p)(succ (cdr p)))(cons zero zero))) | _ -> assert false

    (*arithmetic operators*)
    let add = curry2 (function (N m, N n) -> N (fun f x -> m succ (n f x)) | _ -> assert false)
    let mul = curry2 (function (N m, N n) -> N (fun f x -> m (n f) x)| _ -> assert false)
    let sub = curry2 (function (N m, N n) -> N (fun f x -> m pred(n f x)) | _ -> assert false)

    (*comparators*)
    let is_zero = function (N n) -> (n (fun x -> false') true') | _ -> assert false
    let leq     = curry2 (function (N m, N n) -> is_zero (sub (N m) (N n))| _ -> assert false)
    let equ     = curry2 (function (N m, N n) -> and' (leq (N m) (N n)) (leq (N n) (N m)) | _ -> assert false)
    
    (*
      Y combinator
    *)
    (* the usual def of Y combinator as below does not work
       in the applicative order eval
        let y = fun f -> 
            let k = fun (Fix g) -> f (g (Fix g)) in
            k (Fix k)
    *) 
    let y = fun f -> 
        let k = fun (Fix g) -> f (fun x -> g (Fix g) x) in
        k (Fix k)
    
    (*(*alternatively*)
    let y = fun f -> 
        let k = fun (Fix g) -> fun x -> f (g (Fix g)) x in
        k (Fix k)
    *)
    
    (*
       Helper
    *)
    (*thunk*)
    let force = function T f -> f false' | _ -> assert false
    
    (*convert Church numerals to int*)    
    let to_int a =
        let inc = function I i -> I (i + 1) | _ -> assert false in
        let ret = function I i -> i | _ -> assert false in
        match a with
        | (N n) -> ret (n inc (I 0))
        | (B p) -> ret (p (I 1) (I 0))
        | _ -> assert false
end
    
(*
  Examples
*)
open Church

(*factorial*)    
let fact = 
    let fact' self x =
        force (if' (is_zero x)
                   (T (fun _ -> succ zero))
                   (T (fun _ -> mul x (self (pred x))))) in
    y fact'
    
(*gcd*)    (*
let gcd = 
	let gcd' g a b = 
		force  (if' (equ a b) 
					(T (fun a
					(if' (leq b a)
						(gcd' (sub (N b) (N a)) b)
						(gcd' (sub (N a) (N b)) a))) in
	y gcd'
	*)
 

(*test cases*)
let one   = succ zero
let _     = assert(1 = to_int one)
let two   = add one one
let _     = assert(2 = to_int two)
let three = pred (mul two two)
let _     = assert(3 = to_int three)
let four  = sub (mul two three) two
let _     = assert(4 = to_int four)
let five  = (if' (equ four four) (add four one) zero)
let _     = assert(5 = to_int five)
let six   = (if' (not' (leq four three)) (add three three) zero)
let _     = assert(6 = to_int six)
let seven = (if' (and' (is_zero zero) (is_zero one)) zero (add four three))
let _     = assert(7 = to_int seven)
let eight = (if' (or' (is_zero zero) (is_zero one)) (add four four) zero)
let _     = assert(8 = to_int eight)
let nine  = (car (cons (mul three three) zero))
let _     = assert(9 = to_int nine)
let ten   = (cdr (cons zero (mul two five)))
let _     = assert(10 = to_int ten)
let _     = assert(24 = to_int (fact four))(*
let _     = assert(3  = to_int (gcd six nine))*)
