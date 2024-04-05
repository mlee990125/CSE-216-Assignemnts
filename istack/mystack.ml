module type Istack = sig type 'a stack
val empty: unit -> 'a stack
val is_empty: 'a stack -> bool
val push: 'a -> 'a stack -> 'a stack
val peek: 'a stack -> 'a
val pop: 'a stack -> 'a stack
end

module Stack: Istack = struct
type 'a stack = Nil | Cons of 'a * 'a stack
let empty () = Nil
let is_empty s = (s = Nil)
let push a s = Cons (a, s)
let peek s = match s with | Nil -> assert false | Cons (a, _) -> a
let pop s = match s with | Nil -> assert false | Cons (_, b) -> b
end
