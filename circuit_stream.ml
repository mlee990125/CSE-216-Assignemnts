(*
   stream type
*)
type 'a stream = Nil | Cons of 'a * (unit -> 'a stream);;
let car s = 
    match s with 
    | Cons (x, _) -> x
    | Nil -> assert false

let cdr s =     
    match s with 
    | Cons (_, f) -> f ()
    | Nil -> assert false

(*
   stream of constants
*)   
(* TODO: make a stream of constant c
   e.g. [c;c;c;...]*)
let rec const_stream c = Cons(c, (fun () -> const_stream c))
(*TODO: using const_stream, make a stream of 0s*)

let rec zeros = const_stream 0
(*TODO: using const_stream, make a stream of 1s*)
let rec ones  = const_stream 1


(* TODO: return a stream such that
    for the first delay elements return curr
    for the next elemetns return from stream
   e.g.) after_delay 3 0 [1;1;0;0;...] -> [0;0;0;1;1;0;0;...]   
*)
let rec after_delay delay curr stream =
   if delay = 0 then stream 
   else after_delay (delay - 1) curr (Cons(curr, (fun () -> stream)))

    
(*
   not gate
   TODO: return the negation of the input stream after
   not_gate_delay. Return 0 until not_gate_delay.
   e.g.) if stream is [0;0;0;1;1;1...], then its output stream is
   [0;...;0;1;1;1;0;0;0...], where 0;...;0 means ten 0s.
*)    
let rec not_gate stream =
    let logical_not = fun a -> if a = 1 then 0 else 1 in
    let not_gate_delay = 10 in
    let rec iter strm_a =
    Cons(logical_not (car stream), fun() -> iter(cdr stream))in
    after_delay not_gate_delay 0 (iter stream)


(*
   and gate
   TODO: return the and of the input streams after
   and_gate_delay. Return 0 unntil and_gate_delay.
*) 
let rec and_gate stream_a stream_b = 
    let logical_and = fun a b -> if a = 1 && b = 1 then 1 else 0 in
    let and_gate_delay = 12 in
    let rec iter strm_a strm_b = 
    Cons(logical_and (car stream_a) (car stream_b), fun() -> iter(cdr stream_a) (cdr stream_b)) in
    after_delay and_gate_delay 0 (iter stream_a stream_b)


(*
   or gate
   TODO: return the or of the input streams after
   or_gate_delay. Return 0 until or_gate_delay.
*) 
let rec or_gate stream_a stream_b = 
    let logical_or = fun a b -> if a = 1 || b = 1 then 1 else 0 in
    let or_gate_delay  = 13 in
    let rec iter strm_a strm_b = 
    Cons(logical_or (car stream_a) (car stream_b), fun() -> iter(cdr stream_a) (cdr stream_b)) in
    after_delay or_gate_delay 0 (iter stream_a stream_b)


(*
   half adder
   TODO: return a tuple of sum stream and carry stream
*) 
let half_adder strm_a strm_b = 
   
   let sums = or_gate (and_gate strm_a (not_gate strm_b)) (and_gate strm_b (not_gate strm_a)) in
   let carry = and_gate strm_a strm_b in
   (sums, carry)
   




(*
   full adder
   TODO: return a tuple of sum stream and carry stream
*) 
let full_adder strm_a strm_b strm_cin = 
   let (s, c1) = half_adder strm_b strm_cin in
	let (sum, c2) = half_adder strm_a s in
	let cout = or_gate c1 c2 in
	(sum, cout)


(*
   simulation
   print the contents of sum stream and carry stream
*) 
let simul () = 
    let (strm_sum, strm_carry) = full_adder ones ones ones in
    let maxt = 200 in
    (*param: time, sum stream, carry stream, prev sum, prev carry*)
    let rec iter t strm_s strm_c ps pc = 
        let cs = car strm_s in (*current sum*)
        let cc = car strm_c in (*current carry*)
        
        (* print sum and carry*)
        if (cs <> ps) || (cc <> pc)
        then Printf.printf "[t:%d] s:%d, c:%d\n" t cs cc
        else ();

        
        (* TODO: run the simulation for the rest of sum and carry
        *)
   if (maxt <> t)
			then iter (t + 1) (cdr strm_s) (cdr strm_c) cs cc
			else () in

    iter 0 strm_sum strm_carry 2 2 (*2 2: to print the initial condition*) 


(* expected result
[t:0] s:0, c:0
[t:25] s:1, c:1
[t:59] s:0, c:1
[t:68] s:1, c:1
- : unit = ()
*)
let _ = simul ()