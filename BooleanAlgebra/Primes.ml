(* Product of Primes
   - product will be and_identity
*)
module type IProductOfPrimes = sig
    val product: int
end

(* Build Boolean Algebra of Primes
*)
module PrimesBuilder (ProductOfPrimes: IProductOfPrimes) : (IBooleanAlgebra with type t = int) = struct
    type t = int
    
    (*TODO: implement gcd*)
    let rec gcd a b = 
        if a > b then gcd (a - b) b
        else if a < b then gcd (b - a) a
        else a
        
    (*TODO: implement lcm*)
    let lcm a b =
        (a * b) / gcd a b

    let and_identity = ProductOfPrimes.product
    let or_identity  = 1
    
    (*TODO: or_: lcm, and_: gcd, not_ a: and_identity / a*)
    let or_  a b = lcm a b
    let and_ a b = gcd a b
    let not_ a   = and_identity / a
end    

(* test cases*)
let testPrimes() = 
    let _ = Printf.printf "%s\n%s\n"
        "--------------------------------"
        "Primes testing..." in

    (* TODO: P210 is a Primes whose product is 210*)
    let module P210 = PrimesBuilder(struct let product = 210 end) in
    let module TBAPrimes = TestBooleanAlgebra(P210) in
    let _ = TBAPrimes.testAll 6 15 30 in

    let module P210Dual = BooleanAlgebraBuilderByDual(P210) in
    let module TBAPrimes = TestBooleanAlgebra(P210Dual) in
    let _ = TBAPrimes.testAll 6 15 30 in

    let _ = Printf.printf "%s\n%s\n"
        "Primes testing done: success!"
        "--------------------------------" in
    ()
