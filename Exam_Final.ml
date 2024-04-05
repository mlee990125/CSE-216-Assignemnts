(* CSE216 Programming Abstractions Final Exam
   total 129 pt
   Date: 6/17/2021, 3:15pm ~ 5:45pm
   Name: Michael Lee
   Student Id: 112424954
*)

(* P1. [14 x 2 pt] What are the terms for the folloiwng explanations?
    Choose your answer from: 
    alpha conversion, applicative order, beta reduction, call by name,
    call by reference, call by value, callback, Church-Rosser theorem,
    continuation, delta reduction, eta reduction, fclose, fopen, fread, fwrite, 
    free, local variables, normal order, malloc, scope, stack frame,
    streams, variable binding, Y combinator

    1. In C, a memory block can be allocated in heap using this function: malloc

    2. In C, this function deallocates memory allocated in heap: free

    3. The simplest form of a lambda expression is unique: Church-Rosser theorem

    4. The set of expressions for which a binding defines a name : scope

    5. In lambda calculus, if any evaluation order of an expression terminates, this evaluation order terminates: normal order

    6. This operation on a lambda expression corresponds to a function application: beta reduction

    7. When a function is invoked, this area is created to store temporary variables, local variables, return address, etc: stack frame

    8. To resolve name collision, it renames a variable of a lambda expression: alpha conversion

    9. In this parameter passing mode, copies of the arguments are passed: call by value

    10. In this parameter passing mode, parameters are passed as literal substitutions: call by name

    11. This operator enables recursion in lambda calculus: Y combinator
    
    12. A signle parameter function that represents the rest of the program: continuation

    13. In functional programming, this technique can be used to model side effects like random number generators: streams

    14. In C, this function copies n elements of data from memory to file: fwrite
*)

(* P2. [12 x 2 pt] In the following C program, in which area the folloing pointer expressions are pointing to?
    Choose your answer from: stack, heap, .bss, .data, .text

    #include <stdio.h>
    #include <stdlib.h>

    int e = 10;
    void add(int a, int b, int *q) {
        static int s;
        int c = a + b;
        *q = c;
    }
    int main() {
        int *p = malloc(sizeof(int));
        add(1, 2, p);
        int d = *p;
        char *fmt = "ans: %d\n";
        printf(fmt, d);
        free(p);
    }    

    1. &e: .data

    2. &a: stack

    3. q: heap

    4. &q: stack

    5. &s: .bss

    6. &c: stack

    7. add: .text

    8. p: heap

    9. &p: stack

    10. &d: stack

    11. fmt: .text

    12. main: .text
*)

(*P3. [2 x 5pt] Implement a gcd function and convert it to CPS*)
(*TODO: 1. implement gcd*)
let rec gcd a b =
    if b = 0 then a else gcd b (a mod b)

let _ = gcd 12 30


(*TODO: 2. implement gcd in CPS*)
let rec gcd2 a b k =
  if a = b then
        k a 
    else if a > b then
        gcd2 (a - b) b (fun x -> k x)
    else
        gcd2 (b - a) a (fun x -> k x)

let _ = gcd2 12 30 (fun g -> Printf.printf "gcd: %d\n" g)


(*P4 [2 x 5pt] This problem is about the assignment operation.
  - implement _get_pos and _chg_pos.*)

type position = {
    get_pos: unit -> (int * int);
    chg_pos: int -> int -> (int * int)
}

let make_position x y =
    let pos = ref (x, y) in

    (*TODO: implement _get_pos: get the current position*)
    let _get_pos () = !pos in

  
    (*TODO: implement _chg_pos: change the current position by dx and dy*)
    let _chg_pos dx dy = 
    let apply dx dy =
      let (x, y) = !pos in
      begin
        pos := (x+dx, y+dy);
        !pos 
      end
    in apply dx dy in


    {
        get_pos = _get_pos;
        chg_pos = _chg_pos;
    }

let p = make_position 10 10
let _ = p.get_pos()     (*should be (10, 10)*)
let _ = p.chg_pos 2 3   (*should be (12, 13)*)
let _ = p.get_pos()     (*should be (12, 13)*)


(*P5 [5 x 3pt] This problem is about streams (infinite streams)*)

type 'a stream = Nil | Cons of 'a * (unit -> 'a stream)
let car s = 
    match s with 
    | Nil -> assert false
    | Cons (x, _) -> x 

let cdr s =     
    match s with 
    | Nil -> assert false
    | Cons (_, f) -> f () 

(*TODO: implement map*)

let rec map func strm = 
   Cons ((func (car strm)), (fun () -> map func (cdr strm)))


(*TODO: implement filter*)
let rec filter pred strm =
  if pred (car strm) then Cons ((car strm), (fun () -> filter pred (cdr strm))) else filter pred (cdr strm)

(*TODO: implement nat: stream of natural numbers
e.g. [0, 1, 2, 3, ...]
*)
let rec from x = Cons (x, fun () -> from (x + 1))
let nat = from 0

(*TODO: using map, implement squ: stream of the square of natural numbers
e.g. [0, 1, 4, 9, ...]
*)
let squ = map (fun x -> x * x) nat

(*let squ = Cons*)

(*TODO: using filter, implement odd: stream of odd numbers
e.g. [1, 3, 5, 7, ...]
*)

let odd = filter (fun x -> not (x mod 2 = 0)) nat

let rec print n strm =
    if n = 0 then
        Printf.printf "\n"
    else begin
        Printf.printf "%d " (car strm);
        print (n - 1) (cdr strm)
    end

let _ = print 10 nat
let _ = print 10 squ
let _ = print 10 odd

(*
6 [42 pt] In this problem, we will parse some parts of the the JSON format, a human-readable standard format for data interchange.
    Our JSON data types are:
        - Number: a positive integer
        - String: a sequence of zero or more characters. Strings are delimited with double-quotation marks.
                we do not support escape sequences
        - Boolean: true or false
        - Array: an ordered list of zero or more elements, each of which may be of any type.
                arrays use square bracket notation ('[', ']') with comma-separated elements.
        - Object: a collection of nameâ€“value pairs where the names are strings. 
                objects are delimited with curly brackets ('{', '}') and use commas to separate each pair.
                within each pair the colon ':' character separates the key or name from its value.
        - null: an empty value, using the word null

    Below is an example of a JSON
        {
            "name": "John Smith",
            "isAlive": true,
            "age": 27,
            "address": {
                "city": "New York",
                "state": "NY",
            },
            "phoneNumbers": [
                {
                "type": "home",
                "number": "212 555-1234"
                },
                {
                "type": "office",
                "number": "646 555-4567"
                }
            ],
            "children": [],
            "spouse": null
        }

    * For problem 2 and 3, implement the code in scanner.h and parser.c and
      copy your implementations to this file

    * TO compile the C code in json.zip
        Linux and Mac: gcc *.c
        Windows: gcc -DWIN *.c libregex.a

    1. [6 x 3pt] Write a CFG for object, array, pair, pair_list and value_list for JSON
        STRING, NUMBER, TRUE, FALSE, NULL, ',' '{', '}', '[', ']', ':' are tokens

        json
            -> value
        value
            -> STRING
            |  NUMBER
            |  TRUE
            |  FALSE
            |  NULL
            |  object
            |  array
        opt_value_list  //optional value list
            ->          //possibly empty
            |  value_list

        object          //cannot be empty
            -> {value_list}

        array           //can be empty
            -> [opt_value_list]
        pair
           -> STRING: value
        pair_list    
          -> pair
           |  pair_list, pair

            
        value_list   
          -> value
           |  value_list, value




    2. [2 x 3pt] Add regular expressions for numbers (positive integer) and strings to TOK_REGEXP in scanner.h
#define TOK_REGEXP  "^([ \t\n\r]+)|"                /*whitespace*/\
                    "^(\"[^\\\"]*\")|"               /*string*/\
                    "^([0-9]+)|"                    /*number*/\
                    "^(true)|"                      /*true*/\
                    "^(false)|"                     /*false*/\
                    "^(null)"                      /*null*/

    3. [6 x 3pt] Implement the following functions in parser.c
//TODO: implement parse_object
static void parse_object() {
  match (‘{‘);
	parse_pair_list();
	match(‘}’);

}
//TODO: implement parse_array
static void parse_array() {
  match('[');
  parse_opt_value_list();
  match(']');
}
//TODO: implement parse_pair
static void parse_pair() {
  match(TOK_STR);
  match(':');
  parse_value();
}
//TODO: implement parse_pair_list
static void parse_pair_list() {
  parse_pair();
	while(sc.token == ‘,’) {
		match(‘,’);
		parse_pair();
  }
}
//TODO: implement parse_value
static void parse_value() {
  if (sc.token == TOK_STR) {
        match(TOK_STR);
    } else if (sc.token == TOK_NUM) {
        match(TOK_NUM);
    } else if (sc.token == TOK_TRUE) {
        match(TOK_TRUE);
    } else if (sc.token == TOK_FALSE) {
        match(TOK_FALSE);
    } else if (sc.token == TOK_NULL) {
        match(TOK_NULL);
    } else if (sc.token == '{') {
        parse_object();
    } else if (sc.token == '[') {
        parse_array();
    } else if (sc.token == TOK_EOF) {
        return;
    } else {
        ON_FALSE_EXIT(0, strmsg("Error in line %d: unexpected token %s ",
            sc.line, sc.text));
    }
}
//TODO: implement parse_value_list
static void parse_value_list() {
  parse_value();
    while (sc.token == ',') {
        match(',');
        parse_value();
    }
}
*)
