(*IComparable
*)
module type IComparable = sig
    type t
    (* positive if first > second,
       negative if first < second,
       0 otherwise *)
    val compare: t -> t -> int  
end

(*IInterval
*)
module type IInterval = sig
    (*end point type*)
    type p
    (*interval type*)
    type i = Interval of p * p
           | Empty

    val create: p -> p -> i
    val isEmpty: i -> bool
    val contains: i -> p -> bool
    val intersect: i -> i -> i
end

(*IntervalBuilder
*)
module IntervalBuilder (EndPoint : IComparable) :
                       (IInterval with type p = EndPoint.t) = struct
    type p = EndPoint.t
    type i = Interval of p * p
           | Empty
    
    (*TODO: if lo > hi, Empty; otherwise Interval (lo, hi)*)
    let create lo hi = if (EndPoint.compare lo hi) > 0 then Empty else Interval (lo, hi)
        
    (*TODO: if interval is Empty or not*)
    let isEmpty = function | Empty -> true | Interval _ -> false 
        
    (*TODO: whether p is within interval i*)
    let contains i p = match i with
        | Empty -> false
        | Interval (lo, hi) -> EndPoint.compare p lo >= 0 &&
                               EndPoint.compare hi p >= 0
                             
    (*TODO : intersection of i and j*)
    let intersect i j = 
        let max x y = if EndPoint.compare x y >= 0 then x else y in
        let min x y = if EndPoint.compare x y <= 0 then x else y in
        match i, j with
        | Interval (a, b), Interval (c, d) ->
            create (max a c) (min b d)
        | _ -> Empty

end

(*IntInterval
*)
module IntInterval = struct
    (*TODO: include IInterval with
            EndPoint's type t = int  and
                       comp a b = a - b
    *)
    include

    (*TODO: print [] if interval is Empty
            print [a, b] if interval is Interval (a, b)
    *)
    let print = 
end

(* Expected result:
[3, 8]
[4, 10]
[4, 8]
[]
[]
*)

let a = IntInterval.create 3 8 
let b = IntInterval.create 4 10
let c = IntInterval.intersect a b
let d = IntInterval.create 3 1
let e = IntInterval.intersect c d
let _ = IntInterval.print a;
        IntInterval.print b;
        IntInterval.print c;
        IntInterval.print d;
        IntInterval.print e