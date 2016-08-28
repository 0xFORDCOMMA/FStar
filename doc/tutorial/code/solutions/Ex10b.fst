module Ex10b
//shift

open FStar.Heap
open FStar.ST


type point =
  | Point : x:ref int -> y:ref int{y<>x} -> point

// BEGIN: NewPointType
val new_point: x:int -> y:int -> ST point
  (requires (fun h -> True))
  (ensures (fun h0 p h1 ->
                modifies TSet.empty h0 h1
                /\ Heap.fresh (Point.x p ^+^ Point.y p) h0 h1
                /\ Heap.sel h1 (Point.x p) = x
                /\ Heap.sel h1 (Point.y p) = y
                /\ Heap.contains h1 (Point.x p) //these two lines should be captures by fresh
                /\ Heap.contains h1 (Point.y p)))
// END: NewPointType
// BEGIN: NewPoint
let new_point x y =
  let x = ST.alloc x in
  let y = ST.alloc y in
  Point x y
// END: NewPoint

// BEGIN: ShiftXType
val shift_x: p:point -> ST unit
  (requires (fun h -> True))
  (ensures (fun h0 x h1 -> modifies (only (Point.x p)) h0 h1))
// END: ShiftXType
let shift_x p =
  Point.x p := !(Point.x p) + 1

// BEGIN: ShiftXP1Spec
val shift_x_p1: p1:point
             -> p2:point{   Point.x p2 <> Point.x p1
                          /\ Point.y p2 <> Point.x p1
                          /\ Point.x p2 <> Point.y p1
                          /\ Point.y p2 <> Point.y p1 }
           -> ST unit
    (requires (fun h -> Heap.contains h (Point.x p2)
                    /\  Heap.contains h (Point.y p2)))
    (ensures (fun h0 _ h1 -> modifies (only (Point.x p1)) h0 h1))
// END: ShiftXP1Spec

// BEGIN: ShiftXP1
let shift_x_p1 p1 p2 =
    let p2_0 = !(Point.x p2), !(Point.y p2)  in //p2 is initially p2_0
    shift_x p1;
    let p2_1 = !(Point.x p2), !(Point.y p2) in
    assert (p2_0 = p2_1)                        //p2 is unchanged
// END: ShiftXP1


 (*
//The following wont typecheck
// BEGIN: Test0
val test0: unit -> St unit
let test0 () =
  let p1 = new_point 0 0 in
  shift_x_p1 p1 p1
// END: Test0
*)

// BEGIN: Test1
val test1: unit -> St unit
let test1 () =
  let p1 = new_point 0 0 in
  let p2 = new_point 0 0 in
  shift_x_p1 p1 p2
// END: Test1

// BEGIN Test2
val test2: unit -> St unit
let test2 () =
  let p = new_point 0 0 in
  let z = ST.alloc 0 in
  assert (Point.x p <> z)
// END Test2


let shift p =
  Point.x p := !(Point.x p) + 1;
  Point.y p := !(Point.y p) + 1



// BEGIN: ShiftP1SpecSolution
val shift_p1: p1:point
           -> p2:point{   Point.x p2 <> Point.x p1
                       /\ Point.y p2 <> Point.x p1
                       /\ Point.x p2 <> Point.y p1
                       /\ Point.y p2 <> Point.y p1 }
           -> ST unit
    (requires (fun h -> Heap.contains h (Point.x p2)
                    /\  Heap.contains h (Point.y p2)))
    (ensures (fun h0 _ h1 -> modifies (Point.x p1 ^+^ Point.y p1) h0 h1))
// END: ShiftP1SpecSolution

let shift_p1 p1 p2 =
    let p2_0 = !(Point.x p2), !(Point.y p2)  in //p2 is initially p2_0
    shift p1;
    let p2_1 = !(Point.x p2), !(Point.y p2) in
    assert (p2_0 = p2_1)                        //p2 is unchanged



val test: unit -> St unit
let test () =
  let p1 = new_point 0 0 in
  let p2 = new_point 0 1 in
  shift_p1 p1 p2
