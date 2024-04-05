(*https://caml.inria.fr/pub/docs/oreilly-book/pdf/chap5.pdf*)
#load "graphics.cma";;
open Graphics;;

(*vector 2d
 *)
(*add, sub*)
let add  (x1, y1) (x2, y2) = (x1 +. x2, y1 +. y2)
let sub  (x1, y1) (x2, y2) = (x1 -. x2, y1 -. y2)

(*inner product*)
let prod (x1, y1) (x2, y2) = x1 *. x2 +. y1 *. y2

(*scalar multiplication*)
let smul s (x, y) = (s *. x, s *. y)
    
(*frame
 *)
let new_frame o u v = (o, u, v)
let frame_g = new_frame (0.,0.) (1.,0.) (0.,1.)
let frame_o frame = let (o, _, _) = frame in o
let frame_u frame = let (_, u, _) = frame in u
let frame_v frame = let (_, _, v) = frame in v

let frame_coord_map frame =
    let o = frame_o frame in
    let u = frame_u frame in
    let v = frame_v frame in
    fun (x, y) -> add o (add (smul x u) (smul y v)) 

(*draw*)
let draw painter frame =
    open_graph " 600x600";
    clear_graph ();
    painter frame;
    (*close_graph ()*)
    () 

(*base painter*)
let base_painter =
    let screen_coord (x, y) = 
        (truncate (x *. float (size_x ())),
         truncate (y *. float (size_y ()))) in
    let curry f (x, y) = (f x) y in
    let move_to (x, y) = curry moveto (screen_coord (x, y)) in
    let line_to (x, y) = curry lineto (screen_coord (x, y)) in
    fun frame ->
        let map = frame_coord_map frame in
        let b = 0.99 in
        let a = 1. -. b in
        (*set_color blue;
        move_to (map (a, a));
        line_to (map (b, b));*)
        set_color red;
        move_to (map (a, a));
        line_to (map (a, b));
        line_to (map (b, b));
        line_to (map (b, a));
        line_to (map (a, a))

let p0 = base_painter 
(*
let _ = draw p0 frame_g
*)
(*simple transform on painters*)
let tf_painter painter o x y =
    fun frame -> 
        let map = frame_coord_map frame in
        let o' = map o in
        let u' = map x in
        let v' = map y in
        painter (new_frame o' (sub u' o') (sub v' o')) 

(*beside
 *)
let beside painter_l painter_r =
    let paint_left  = tf_painter painter_l (0.,0.)  (0.5,0.) (0.,1.)  in
    let paint_right = tf_painter painter_r (0.5,0.) (1.,0.)  (0.5,1.) in
    fun frame ->
        paint_left  frame;
        paint_right frame 


let p1 = beside p0 p0
(*
let _ = draw  p1 frame_g
*)
let p2 = beside p0 p1
(*
let _ = draw  p2 frame_g
*)
let p3 = beside p0 p2
(*
let _ = draw  p3 frame_g
*)

(*besides
 *)
let rec besides n =
  if n = 0 then p0 
  else besides p0 (besides (n-1))

let _ = draw (besides 8) frame_g
(*
(*below
 *)
let below painter_t painter_b =
    let paint_top    = 
    let paint_bottom = 
    fun frame ->

let p1 = below p0 p0
let _ = draw p1 frame_g


let p2 = 
let p3 = 
let _ = draw p3 frame_g


let p4 = 
let _ = draw p4 frame_g


(*belows
 *)
let rec belows n =

let _ = draw (belows 8) frame_g
*)