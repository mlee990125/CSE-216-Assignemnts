(*-------------------------------------
  Robot commands
-------------------------------------*)

(*move from pose to target_pose*)
let moveto_pose b_camera robot (pose, board) target_pose =    
    let db  = (getpose target_pose "base")   -. (getpose pose "base") in
    let da1 = (getpose target_pose "arm1")   -. (getpose pose "arm1") in
    let da2 = (getpose target_pose "arm2")   -. (getpose pose "arm2") in
    let df  = (getpose target_pose "finger") -. (getpose pose "finger") in
    
    (*move the joint <ang> angle in <step> steps
      e.g. rotate arm1 30 deg in 5 steps
           => rotate arm1 5 times 6 deg each
    *)
        (*TODO: implement this method
            - on each step, draw the robot and the board
            - wait for 50ms by calling Thread.delay 0.05
            - then either return pose or rotate more
        *)
    let rec rot_joint pose joint ang step = match step with
        |0 -> pose
        |x -> let pose2 =  chgpose pose joint (ang /. (float_of_int) x) in
                    draw b_camera robot pose2 board;
                    Thread.delay 0.05;
                    rot_joint pose2 joint (ang -. (ang /. (float_of_int) x))  (x - 1) in

    (*move the joints in base, arm1, arm2, and finger order*)
    let p = pose |> fun p -> rot_joint p "base" db  5
                 |> fun p -> rot_joint p "arm1" da1 5
                 |> fun p -> rot_joint p "arm2" da2 5
                 |> fun p -> rot_joint p "finger" df 3 in
    (p, board)

(*pick the mart at index i*)
let pick (pose, board) i =
    let f = getpose pose "finger" in
    let m = getmark board i in
    (*TODO: return (p, b), where p is the pose whose
            mark and finger are switched to m and 0. respectively
            and b is the board whose mark at i is removed.
        e.g.     pick ((1.,1.,1.,10.,mark_n), [mark_x;mark_o;...]) 1
        should return ((1.,1.,1.,0., mark_o), [mark_x;mark_n;...])
    *)
    ((chgpose (chgpose pose "mark" m) "finger" (-.f)), board)

(*dropt the mart at index i*)
let drop (pose, board) i =
    let f = getpose pose "finger" in
    let m = getpose pose "mark" in
    let j = if m = mark_o then 9 else 10 in
    
    (*TODO: return (p, b),
            where b is board with its i-th and j-th marks replaced by m
            and p is pose whose mark and finger are switched
            to mark_n and 10. respectively
        e.g.     drop ((1.,1.,1.,0., mark_o), [mark_x;mark_n;...]) 1
        should return ((1.,1.,1.,10.,mark_n), [mark_x;mark_o;...])
    *)
    let p = chgpose (chgpose pose "mark" mark_n) "finger" (10. -. f) in
    let b = chgmark board i m in
    (p, b)

(*mark at index i with mark*)
let mark b_camera robot (pose, board) mrk i =
    let f = getpose pose "finger" in
    let m = getpose pose "mark" in
    let j = if mrk = mark_o then 9 else 10 in
    (*moveto_pose with the first two params passed*)
    let mvp = moveto_pose b_camera robot in
    (*TODO: 1) find b, a1, and a2 for ipose and jpose
        using curry3, find_pose, mark_pos then
        2) pass two params for the fun returned by find_pose
    *)        
    let ipose = (curry3 find_pose (mark_pos i)) f m in(*robot pose for the i-th mark*)
    let jpose = (curry3 find_pose (mark_pos j)) f m in(*robot pose for the j-th mark*)
    (pose, board)
        |> fun (p, b) -> mvp (p, b) jpose
        |> fun (p, b) -> pick (p, b) j
        |> fun (p, b) -> mvp (p, b) (lift_pose p)
        |> fun (p, b) -> mvp (p, b) ipose
        |> fun (p, b) -> drop (p, b) i
        |> fun (p, b) -> mvp (p, b) (lift_pose p)

    (*TODO: 1. move to position jpose
            2. pick the mark at j
            3. lift
            4. move to position ipose
            5. drop the mark at i
            6. lift
            7. return the resulting pose and the board*)

