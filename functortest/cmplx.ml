type complex = Rect of float * float | Polar of float * float;;
(*constructors*)
let rect r i = Rect (r, i)
let polar m a = Polar (m, a)
(*accessors*)
let re = function | Rect (r, i) -> r | Polar (m, a) -> m *. cos(a)
let im = function | Rect (r, i) -> i | Polar (m, a) -> m *. sin(a)
let mag = function | Rect (r, i) -> sqrt (r *. r +. i *. i) | Polar (m, a) -> m
let ang = function | Rect (r, i) -> atan2 i r | Polar (m, a) -> a
let add a b = rect (re a +. re b) (im a +. im b)
let sub a b = rect (re a -. re b) (im a -. im b)
let mul a b = polar (mag a *. mag b) (ang a +. ang b)
let div a b = polar (mag a /. mag b) (ang a -. ang b)
let to_str = function | Rect (r, i) -> Printf.sprintf "%f + %fi" r i | Polar (m, a) -> Printf.sprintf "%f / %f" m a