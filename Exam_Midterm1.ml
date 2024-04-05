(* CSE216 Programming Abstractions
   Midterm Exam 1 [total 123pt]
   Date: 4/13/2021, 5:00pm ~ 6:20pm
   Name: Michael Lee
   Student Id: 112424954
*)

(* P1 [6 x 2pt] What is the programming language paradigm for the following explanation?
    Choose your answer from Procedural programming, Object oriented programming,
    Functional programming, Logic programming, Imperative programming,
    Declarative programming

    a. Describe the logic of the program without specifying the evaluation steps: declarative programming

    b. Programming is based on updating states and taking actions based on the state: Imperative programming

    c. Programs are composed of objects: object oriented programming

    d. An imperative programming whose main abstraction mechanism is procedures: procedural

    e. A declarative programming that finds a result through rules and axioms: logic programming

    f. Programming is based on defining recurisve functions: Functional programming
*)

(* P2. [20 x 2pt] What are the terms for the folloiwng explanations?
    Choose your answer from: 
    algebraic data type, application order, compiling, currying, dynamic scoping, 
    free variable, functor, high order procedure, include, lexical scoping,
    linking, list, module, normal order, open, recursive data type, 
    scope, source-to-source translation, tuple, variable binding 

    a. In this process, symbols of your program are converted to addresses of programming
       elements in other programs: 

    b. Converting a source code, like C++, to another source code like C: source-to-source translation

    c. In this process, your source program is converted to assembly code: compiling

    d. Converting a multi-parameter function to a nested single parameter function: curring

    e. Do not evaluate the operands until their values are needed: normal order

    f. Evaluate all arguments and then apply the procedure: application order

    g. The set of expressions for which a binding defines a name: scope

    h. A variable that is not bound: free variable

    i. Associate variable names with values: variable binding

    j. Find the binding from the closest nesting procedures and let bindings: lexical scoping

    k. Find the binding from the closest stack frame: dynamic scoping

    l. Procedures that accept procedures as arguments and return a procedure: higher order procedures

    m. A collection of any number of items of the same type: list

    n. Ordered collection of values of possibly different types: tuple

    o. A data type that representing one of many possibilities: algebraic data type

    p. Data type for values that contain other values of the same type: recursive data type

    q. A function from modules to a module: functor

    r. Coherent parts of a program that can be developed and maintained separately: module

    s. An OCaml keyword to extend a module from existing ones: include

    t. An OCaml keyword to skip prefixing a module name.
        e.g. to write printf instead of Prinf.print: open
*)

(* P3. [8 x 4pt] Write a simple OCaml code the the following questions
    a. Convert the following to a curried function
       fun (a, b) -> a + b : let curry f = fun x -> fun y -> f(x, y)
       let _ = curry (fun (a, b) -> a + b)

    b. Using the composition operator (|>), rewrite the following nested
       function calls
        cons a (cons b (cons c nil)) : nil |> cons c |> cons b |> cons a

    c. Write a factorial function fact n that returns n!
        let rec fact n = if n = 0 then 1 else n * fact (n - 1)

    d. Write a high order function that taks a function f and returns
       a function g such that g(x) = f(x) * f(x):
       let g f x = (f x) * (f x)
       

    e. Rewrite the list [1;2;3] using :: operators:
      1::2::3::[]

    f. Using map, write a function that takes a list and returns a list
       whose elements are triple of the original elements.
       That is, it returns [3;6;9] for [1;2;3]:
       let rec map f list = match list with
        | [] -> []
        | hd :: tail -> (f hd) :: (map f tail)

        let trip list = map (fun x -> x * 3) list

        let _ = trip [1;2;3]

    



    g. Write a function with a parameter s that returns 1 with a backtick tag `Int 
       if s is true or "one" with a backtick tag `Str if s is false:
       let func s = if s then `Int 1 else `Str "one"

    h. Write a module Int that implements a module signature IInt 
        module type IInt = sig
            val add: int -> int -> int (*int addition*)
            val mul: int -> int -> int (*int multiplication*)
        end

        module Int : IInt = struct
          let add a b = a + b
          let mul a b = a * b
        end


*)


(* P4. [13 x 3pt] In this problem we build class modules using a functor,
       student modules and list modules.
    Implement the TODOs in the following modules.
*)

module type IStudent = sig
    type t_student
    val make : string -> int -> t_student
    val name : t_student -> string
    val score : t_student -> int
end

module Student1 : IStudent = struct
    type t_student = string * int

    (*a. [3 pt] TODO: implement make function*)
    let make name score = (name, score)

    (*b. [3 pt] TODO: implement name function*)
    let name student = match student with | (n, _) -> n | _ -> assert(false)

    (*c. [3 pt] TODO: implement score function*)
    let score student = match student with | (_, s) -> s | _ -> assert(false)

end

module Student2 : IStudent = struct
    type s = Name of string | Score of int
    type t_student = string -> s

    let make name score = 
        function
        | "name"  -> Name name
        | "score" -> Score score
        | _ -> assert false

    let name student =
        let remove_tag = function Name n -> n | _-> assert false in
        student "name" |> remove_tag

    let score student =
        let remove_tag = function Score s -> s | _-> assert false in  
        student "score" |> remove_tag
end

module type IList = sig
    type 'a lst

    val cons: 'a -> 'a lst -> 'a lst
    val car: 'a lst -> 'a
    val cdr: 'a lst -> 'a lst
    val nil: 'a lst
    val is_nil: 'a lst -> bool
end

module List1 : IList = struct
    type 'a lst = 'a list

    (*d. [3 pt] TODO: implement cons: it prepends head to tail list*)
    let cons head tail = head :: tail

    (*e. [3 pt] TODO: implement car: it returns the first element of lst*)
    let car lst = match lst with | hd :: tl -> hd | [] -> assert false

    (*f. [3 pt] TODO: implement cdr: it returns the list without the first element of lst*)
    let cdr lst = match lst with | hd :: tl -> tl | [] -> assert false

    let nil = []

    let is_nil lst = (lst = [])
end

module List2 : IList = struct
    type 'a l = Nil | Car of 'a | Cdr of (string -> 'a l)
    type 'a lst = string -> 'a l

    (*g. [3 pt] TODO: implement cons using a high order function.
        cons returns a function that takes a string parameter and
        returns Car head if param is "car" and Cdr tail if param is "cdr"
    *)
    let cons head tail = function | "car" -> Car head | "cdr" -> Cdr tail | _ -> assert false

    (*h. [3 pt] TODO: implement car: returns the first element of lst
         without the Car tag*)
    let car lst =
        let remove_tag = function Car head -> head | _ -> assert false in
        match lst with | hd :: tl -> remove_tag hd | _ -> assert false
        

    (*i. [3 pt] TODO: implement cdr: returns lst except for the first element of lst
         remove the Cdr tag*)
    let cdr lst =
        let remove_tag = function Cdr tail -> tail | _ -> assert false in
        match lst with | hd :: tl -> remove_tag tl | _ -> assert false


    let nil = fun s -> Nil

    let is_nil lst = (lst "car" = Nil)
end


module type IClass = sig
    val print : unit -> unit
end

module MakeClass (S:IStudent) (L:IList) : IClass = struct
    let rec iter f lst =
        if L.is_nil lst then
            ()
        else begin
            f (L.car lst);
            iter f (L.cdr lst)
        end

    (*j. [3 pt] TODO: implement the map function*)
    let rec map f lst = match lst with | [] -> [] | hd :: tl -> (f hd) :: (map f tl)

    (*k. [3 pt] TODO: implement the filter function*)
    let rec filter f lst = match lst with | [] -> [] | hd :: tl -> if f hd then hd::(filter f tl) else filter f tl

    (*l. [3 pt] TODO: using map implement double_score
        returns a list of students whose socres are twice of the original
    *)
    let double_score lst = map (fun x -> x * 2) lst

    (*m. [3 pt] TODO: using filter implement high_score
        returns a list of students whose socre is higher than 70
    *)
    let high_score lst = filter (fun x -> x > 70) lst

    let print lst = 
        iter (fun s -> Printf.printf "%s: %d,\t" (S.name s) (S.score s)) lst
    
    let raw_class =
        L.nil
        |> L.cons (S.make "E" 10)
        |> L.cons (S.make "D" 20)
        |> L.cons (S.make "C" 30)
        |> L.cons (S.make "B" 40)
        |> L.cons (S.make "A" 50)

    let print () =
        let adjusted = double_score raw_class in
        Printf.printf "-- print --\n";
        print adjusted;
        Printf.printf "\n-- print_high --\n";
        high_score adjusted |> print;
        Printf.printf "\n"
end

module Class1 = MakeClass (Student1) (List1)
let _ = Class1.print ()

module Class2 = MakeClass (Student2) (List1)
let _ = Class2.print ()

module Class3 = MakeClass (Student1) (List2)
let _ = Class3.print ()

module Class4 = MakeClass (Student2) (List2)
let _ = Class4.print ()

(* expected results
    -- print --
    A: 100, B: 80,  C: 60,  D: 40,  E: 20,
    -- print_high --
    A: 100, B: 80,
*)        