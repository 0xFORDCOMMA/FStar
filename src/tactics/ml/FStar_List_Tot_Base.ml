open Prims
let isEmpty l = match l with | [] -> true | uu____15 -> false
let hd uu___16_33 = match uu___16_33 with | hd::uu____37 -> hd
let tail uu___17_56 = match uu___17_56 with | uu____59::tl -> tl
let tl = tail
let rec length uu___18_87 =
  match uu___18_87 with
  | [] -> Prims.parse_int "0"
  | uu____89::tl1 -> (Prims.parse_int "1") + (length tl1)
let rec nth l n =
  match l with
  | [] -> None
  | hd1::tl1 ->
      if n = (Prims.parse_int "0")
      then Some hd1
      else nth tl1 (n - (Prims.parse_int "1"))
let rec index l i =
  if i = (Prims.parse_int "0")
  then hd l
  else index (tl l) (i - (Prims.parse_int "1"))
let rec count x uu___19_205 =
  match uu___19_205 with
  | [] -> Prims.parse_int "0"
  | hd1::tl1 ->
      if x = hd1 then (Prims.parse_int "1") + (count x tl1) else count x tl1
let rec rev_acc l acc =
  match l with | [] -> acc | hd1::tl1 -> rev_acc tl1 (hd1 :: acc)
let rev l = rev_acc l []
let rec append x y = match x with | [] -> y | a::tl1 -> a :: (append tl1 y)
let op_At x y = append x y
let rec flatten l =
  match l with | [] -> [] | hd1::tl1 -> append hd1 (flatten tl1)
let rec map f x = match x with | [] -> [] | a::tl1 -> (f a) :: (map f tl1)
let rec mapi_init f l i =
  match l with
  | [] -> []
  | hd1::tl1 -> (f i hd1) :: (mapi_init f tl1 (i + (Prims.parse_int "1")))
let mapi f l = mapi_init f l (Prims.parse_int "0")
let rec concatMap f uu___20_494 =
  match uu___20_494 with
  | [] -> []
  | a::tl1 -> append (f a) (concatMap f tl1)
let rec fold_left f x y =
  match y with | [] -> x | hd1::tl1 -> fold_left f (f x hd1) tl1
let rec fold_right f l x =
  match l with | [] -> x | hd1::tl1 -> f hd1 (fold_right f tl1 x)
let rec fold_left2 f accu l1 l2 =
  match (l1, l2) with
  | ([],[]) -> accu
  | (a1::l11,a2::l21) -> fold_left2 f (f accu a1 a2) l11 l21
let rec mem x uu___21_701 =
  match uu___21_701 with
  | [] -> false
  | hd1::tl1 -> if hd1 = x then true else mem x tl1
let rec memP = Obj.magic (fun x  -> fun l  -> ())
let contains uu____754 = mem
let rec existsb f l =
  match l with
  | [] -> false
  | hd1::tl1 -> if f hd1 then true else existsb f tl1
let rec find f l =
  match l with
  | [] -> None
  | hd1::tl1 -> if f hd1 then Some hd1 else find f tl1
type ('Aa,'Af,'Am,'Au) mem_filter_spec = Obj.t
let rec filter f uu___22_898 =
  match uu___22_898 with
  | [] -> []
  | hd1::tl1 -> if f hd1 then hd1 :: (filter f tl1) else filter f tl1
let mem_filter f l x = ()
let mem_filter_forall f l = ()
let rec for_all f l =
  match l with
  | [] -> true
  | hd1::tl1 -> if f hd1 then for_all f tl1 else false
let rec collect f l =
  match l with | [] -> [] | hd1::tl1 -> append (f hd1) (collect f tl1)
let rec tryFind p l =
  match l with
  | [] -> None
  | hd1::tl1 -> if p hd1 then Some hd1 else tryFind p tl1
let rec tryPick f l =
  match l with
  | [] -> None
  | hd1::tl1 ->
      (match f hd1 with | Some x -> Some x | None  -> tryPick f tl1)
let rec choose f l =
  match l with
  | [] -> []
  | hd1::tl1 ->
      (match f hd1 with
       | Some x -> x :: (choose f tl1)
       | None  -> choose f tl1)
let rec partition f uu___23_1213 =
  match uu___23_1213 with
  | [] -> ([], [])
  | hd1::tl1 ->
      (match partition f tl1 with
       | (l1,l2) -> if f hd1 then ((hd1 :: l1), l2) else (l1, (hd1 :: l2)))
let rec subset la lb =
  match la with | [] -> true | h::tl1 -> (mem h lb) && (subset tl1 lb)
let rec noRepeats la =
  match la with
  | [] -> true
  | h::tl1 -> (Prims.op_Negation (mem h tl1)) && (noRepeats tl1)
let rec assoc x uu___24_1334 =
  match uu___24_1334 with
  | [] -> None
  | (x',y)::tl1 -> if x = x' then Some y else assoc x tl1
let rec split l =
  match l with
  | [] -> ([], [])
  | (hd1,hd2)::tl1 ->
      (match split tl1 with | (tl11,tl2) -> ((hd1 :: tl11), (hd2 :: tl2)))
let unzip uu____1430 = split
let rec unzip3 l =
  match l with
  | [] -> ([], [], [])
  | (hd1,hd2,hd3)::tl1 ->
      (match unzip3 tl1 with
       | (tl11,tl2,tl3) -> ((hd1 :: tl11), (hd2 :: tl2), (hd3 :: tl3)))
let rec partition_length f l = ()
let bool_of_compare f x y = (f x y) > (Prims.parse_int "0")
let compare_of_bool rel x y =
  if rel x y
  then Prims.parse_int "1"
  else if x = y then Prims.parse_int "0" else Prims.parse_int "-1"
let rec sortWith f uu___25_1649 =
  match uu___25_1649 with
  | [] -> []
  | pivot::tl1 ->
      (match partition (bool_of_compare f pivot) tl1 with
       | (hi,lo) -> append (sortWith f lo) (pivot :: (sortWith f hi)))
let test_sort: Prims.unit = ()
let rec strict_prefix_of = Obj.magic (fun l1  -> fun l2  -> ())