open Printf
let message = "Hello"
let hello () = printf "%s\n" message
let print_list lst = List.iter (fun s -> printf "%s\n" s) lst