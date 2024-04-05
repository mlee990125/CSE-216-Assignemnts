(*Name: Ulukbek Aitmatov
  studentID: 112363990
  @mail: ulukbek.aitmatov@stonybrook.edu*)
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
(*TODO: make a stream of constant c*)
let rec const_stream c = Cons (c, (fun () -> const_stream c))
(*TODO: using const_stream, make a stream of 0s*)
let rec zeros = const_stream 0
(*TODO: using const_stream, make a stream of 1s*)
let rec ones  = const_stream 1


(* TODO: return a stream that switches
   to stream from curr (current value) after delay
   e.g.) after_delay 3 0 [1;1;0;0;...] -> [0;0;0;1;1;0;0;...]   
*)
let rec after_delay delay curr stream = 
	if delay == 0 
		then stream
		else after_delay (delay - 1) curr (Cons (curr, (fun () -> stream)))
    
(*
   not gate
   TODO: return a stream that switches
   to the negation of input after not_gate_delay
*)    
let rec not_gate input =
    let logical_not a = if a = 1 then 0 else 1 in
    let not_gate_delay = 10 in
    let rec iter a = 
		Cons (logical_not (car a), fun () -> iter (cdr a)) in
	let curr = 0 in (*current value*)
	after_delay not_gate_delay curr (iter input)


(*
   and gate
   TODO: return a stream that switches
   to the conjunction of a1 and a2 after and_gate_delay
*) 
let rec and_gate a1 a2 = 
    let logical_and a b = if a = 1 && b = 1 then 1 else 0 in
    let and_gate_delay = 12 in
    let rec iter a1 a2 = 
		Cons (logical_and (car a1) (car a2), fun () -> iter (cdr a1) (cdr a2)) in
	let curr = 0 in (*current value*)
	after_delay and_gate_delay curr (iter a1 a2)


(*
   or gate
   TODO: return a stream that switches
   to the disjunction of a1 and a2 after and_gate_delay   
*) 
let rec or_gate a1 a2 = 
    let logical_or a b = if a = 1 || b = 1 then 1 else 0 in
    let or_gate_delay  = 13 in
    let rec iter a1 a2 = 
		Cons ( logical_or (car a1) (car a2), fun () -> iter (cdr a1) (cdr a2)) in
	let curr = 0 in (*current value*)
	after_delay or_gate_delay curr (iter a1 a2)

(*
   half adder
   TODO: return a tuple of sum stream and carry stream
*) 
let half_adder a b = 
	let d = or_gate a b in
	let c = and_gate a b in
	let e = not_gate c in
	let s = and_gate d e in
	(s, c)

(*
   full adder
   TODO: return a tuple of sum stream and carry stream
*) 
let full_adder a b cin = 
	let (s, c1) = half_adder b cin in
	let (sum, c2) = half_adder a s in
	let cout = or_gate c1 c2 in
	(sum, cout)

(*
   simulation
   print the contents of sum stream and carry stream
*) 
let simul () = 
    let (sum, carry) = full_adder ones ones ones in
    let maxt = 200 in
    (*param: time, sum stream, carry stream, prev sum, prev carry*)
    let rec iter t s c ps pc = 
        let cs = car s in (*current sum*)
        let cc = car c in (*current carry*)
        
        (* print sum and carry*)
        if (cs <> ps) || (cc <> pc)
        then Printf.printf "[t:%d] s:%d, c:%d\n" t cs cc
        else ();
        
        (* TODO: run the simulation for the rest of sum and carry*)
		if (maxt <> t)
			then iter (t + 1) (cdr s) (cdr c) cs cc
			else () in
    iter 0 sum carry 2 2 (*2 2: to print the initial condition*) 


(* expected result
[t:0] s:0, c:0
[t:25] s:1, c:1
[t:59] s:0, c:1
[t:68] s:1, c:1
- : unit = ()
*)
let _ = simul ()
