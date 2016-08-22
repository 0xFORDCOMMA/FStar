
open Prims
# 3 "FStar.Ident.fst"
type ident =
{idText : Prims.string; idRange : FStar_Range.range}

# 5 "FStar.Ident.fst"
let is_Mkident : ident  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkident"))))

# 6 "FStar.Ident.fst"
type lident =
{ns : ident Prims.list; ident : ident; nsstr : Prims.string; str : Prims.string}

# 8 "FStar.Ident.fst"
let is_Mklident : lident  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mklident"))))

# 11 "FStar.Ident.fst"
type lid =
lident

# 13 "FStar.Ident.fst"
let mk_ident : (Prims.string * FStar_Range.range)  ->  ident = (fun _25_11 -> (match (_25_11) with
| (text, range) -> begin
{idText = text; idRange = range}
end))

# 15 "FStar.Ident.fst"
let reserved_prefix : Prims.string = "uu___"

# 16 "FStar.Ident.fst"
let gen : FStar_Range.range  ->  ident = (
# 18 "FStar.Ident.fst"
let x = (FStar_Util.mk_ref 0)
in (fun r -> (
# 19 "FStar.Ident.fst"
let _25_14 = (let _117_25 = ((FStar_ST.read x) + 1)
in (FStar_ST.op_Colon_Equals x _117_25))
in (let _117_29 = (let _117_28 = (let _117_27 = (let _117_26 = (FStar_ST.read x)
in (Prims.string_of_int _117_26))
in (Prims.strcat reserved_prefix _117_27))
in ((_117_28), (r)))
in (mk_ident _117_29)))))

# 19 "FStar.Ident.fst"
let id_of_text : Prims.string  ->  ident = (fun str -> (mk_ident ((str), (FStar_Range.dummyRange))))

# 20 "FStar.Ident.fst"
let text_of_id : ident  ->  Prims.string = (fun id -> id.idText)

# 21 "FStar.Ident.fst"
let text_of_path : Prims.string Prims.list  ->  Prims.string = (fun path -> (FStar_Util.concat_l "." path))

# 22 "FStar.Ident.fst"
let path_of_text : Prims.string  ->  Prims.string Prims.list = (fun text -> (FStar_String.split (('.')::[]) text))

# 23 "FStar.Ident.fst"
let path_of_ns : ident Prims.list  ->  Prims.string Prims.list = (fun ns -> (FStar_List.map text_of_id ns))

# 24 "FStar.Ident.fst"
let path_of_lid : lident  ->  Prims.string Prims.list = (fun lid -> (FStar_List.map text_of_id (FStar_List.append lid.ns ((lid.ident)::[]))))

# 25 "FStar.Ident.fst"
let ids_of_lid : lident  ->  ident Prims.list = (fun lid -> (FStar_List.append lid.ns ((lid.ident)::[])))

# 26 "FStar.Ident.fst"
let lid_of_ids : ident Prims.list  ->  lident = (fun ids -> (
# 28 "FStar.Ident.fst"
let _25_26 = (FStar_Util.prefix ids)
in (match (_25_26) with
| (ns, id) -> begin
(
# 29 "FStar.Ident.fst"
let nsstr = (let _117_46 = (FStar_List.map text_of_id ns)
in (FStar_All.pipe_right _117_46 text_of_path))
in {ns = ns; ident = id; nsstr = nsstr; str = if (nsstr = "") then begin
id.idText
end else begin
(Prims.strcat nsstr (Prims.strcat "." id.idText))
end})
end)))

# 33 "FStar.Ident.fst"
let lid_of_path : Prims.string Prims.list  ->  FStar_Range.range  ->  lident = (fun path pos -> (
# 35 "FStar.Ident.fst"
let ids = (FStar_List.map (fun s -> (mk_ident ((s), (pos)))) path)
in (lid_of_ids ids)))

# 36 "FStar.Ident.fst"
let text_of_lid : lident  ->  Prims.string = (fun lid -> lid.str)

# 37 "FStar.Ident.fst"
let lid_equals : lident  ->  lident  ->  Prims.bool = (fun l1 l2 -> (l1.str = l2.str))

# 38 "FStar.Ident.fst"
let lid_with_range : lid  ->  FStar_Range.range  ->  lident = (fun lid r -> (
# 40 "FStar.Ident.fst"
let id = (
# 40 "FStar.Ident.fst"
let _25_37 = lid.ident
in {idText = _25_37.idText; idRange = r})
in (
# 41 "FStar.Ident.fst"
let _25_40 = lid
in {ns = _25_40.ns; ident = id; nsstr = _25_40.nsstr; str = _25_40.str})))

# 41 "FStar.Ident.fst"
let range_of_lid : lid  ->  FStar_Range.range = (fun lid -> lid.ident.idRange)

# 42 "FStar.Ident.fst"
let set_lid_range : lident  ->  FStar_Range.range  ->  lident = (fun l r -> (
# 44 "FStar.Ident.fst"
let ids = (FStar_All.pipe_right (FStar_List.append l.ns ((l.ident)::[])) (FStar_List.map (fun i -> (mk_ident ((i.idText), (r))))))
in (lid_of_ids ids)))

# 45 "FStar.Ident.fst"
let lid_add_suffix : lident  ->  Prims.string  ->  lident = (fun l s -> (
# 47 "FStar.Ident.fst"
let path = (path_of_lid l)
in (lid_of_path (FStar_List.append path ((s)::[])) (range_of_lid l))))




