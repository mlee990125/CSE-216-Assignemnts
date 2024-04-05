(* Universal Set
*)
module type ISetUniverse = sig
    type t
    val universe: t list
end

(* SubsetPrimesMorphism: Morphism between Subset and Bool
*)
module SubsetPrimesMorphism
    (SetUniverse:ISetUniverse) : (IPrimesMorphism with type t = SetUniverse.t list) = struct

    let primes = [2; 3; 5; 7; 11; 13; 17; 19; 23] 
    
    type t = SetUniverse.t list

    (*TODO: and_identity is SetUniverse.universe
    *)
    let and_identity = SetUniverse.universe


    let rec elementAt i list = match list, i with | [], _ -> assert false | _, i when i < 0 -> assert false | hd :: _, 0 -> hd | hd :: tl, i -> elementAt (i-1) tl

    (*TODO: convert a subset to the product of corresponding primes
        e.g. {a, c, d} of {a, b, c, d} => 2*5*7
    *)
    let m2p lst = 
        let rec m2p_aux lst p uni = 
            match lst, p, uni with
            | hd :: tl, hp :: tp, huni :: tuni -> if (hd = huni) then hp * m2p_aux tl tp tuni else m2p_aux lst tp tuni
            |_ -> 1 in
        m2p_aux lst primes and_identity
    
    

    (*TODO: convert a product of primes to a corresponding subset
        e.g. 2*3*7 => {a, b, d} of {a, b, c, d} 
    *)
    let p2m n =
        let rec p2m_aux n uni p = 
            match uni, p with
            |huni :: tuni, hp :: tp -> if (n mod hp = 0) then huni :: p2m_aux (n / hp) tuni tp else p2m_aux n tuni tp
            | _ ->  [] in 
            p2m_aux n and_identity primes
       


end

(* test cases*)
let testSubset() = 
    let _ = Printf.printf "%s\n%s\n"
        "--------------------------------"
        "Subset testing..." in

    (* TODO: Subset is BooleanAlgebra whose universe is ['a'; 'b'; 'c'; 'd']*)
    let module Subset = BooleanAlgebraBuilderByPrimes(SubsetPrimesMorphism(struct type t = char let universe = ['a';'b';'c';'d'] end))in
    let module TBASubset = TestBooleanAlgebra(Subset) in
    let _ = TBASubset.testAll ['a'; 'b'] ['b'; 'c'] ['a'; 'b'; 'c'] in

    let module SubsetDual = BooleanAlgebraBuilderByDual(Subset) in
    let module TBASubset = TestBooleanAlgebra(SubsetDual) in
    let _ = TBASubset.testAll ['a'; 'b'] ['b'; 'c'] ['a'; 'b'; 'c'] in

    let _ = Printf.printf "%s\n%s\n"
        "Subset testing done: success!"
        "--------------------------------" in
    ()
